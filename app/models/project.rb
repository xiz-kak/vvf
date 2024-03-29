# == Schema Information
#
# Table name: projects
#
#  id                 :integer          not null, primary key
#  category_id        :integer
#  goal_amount        :float
#  duration_days      :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :integer
#  applied_begin_date :datetime
#  status_div         :integer
#  code               :string
#  begin_at           :datetime
#  end_at             :datetime
#  view_begin_at      :datetime
#  view_end_at        :datetime
#  paypal_account     :string
#  commission_rate    :integer
#
# Indexes
#
#  index_projects_on_category_id  (category_id)
#  index_projects_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_2ad2693164  (category_id => categories.id)
#  fk_rails_b872a6760a  (user_id => users.id)
#

class Project < ActiveRecord::Base
  include NumberFormatter

  scope :active, -> { where('view_begin_at <= ? AND view_end_at > ? AND status_div = ?',
                            Time.now, Time.now, Divs::ProjectStatus::ACTIVE.value) }

  bind_inum :status_div, Divs::ProjectStatus

  belongs_to :category
  belongs_to :user
  has_many :project_locales, dependent: :destroy, inverse_of: :project
  has_many :project_headers, dependent: :destroy, inverse_of: :project
  has_many :project_contents, dependent: :destroy, inverse_of: :project
  has_many :rewards, -> { order(:price, :count, :id) }, dependent: :destroy, inverse_of: :project
  has_one :project_pledge_summary, primary_key: :code, foreign_key: :project_code, dependent: :destroy, inverse_of: :project

  accepts_nested_attributes_for :project_locales, allow_destroy: true
  accepts_nested_attributes_for :project_headers, allow_destroy: true
  accepts_nested_attributes_for :project_contents, allow_destroy: true
  accepts_nested_attributes_for :rewards, allow_destroy: true

  validates :code, presence: true, length: { maximum: 50 }, format: { with: /\A[a-z0-9\-]+\z/i }
  validates :category, presence: true
  validates :goal_amount, presence: true,
             numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :duration_days, presence: true,
             numericality: {
               only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 60
             }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :paypal_account, presence: true, format: { with: VALID_EMAIL_REGEX }
  validate :main_language_is_used

  END_OF_THE_WORLD = Time.parse('2999/12/31')

  def title(locale)
    localed_header(locale) ? localed_header(locale).title : ''
  end

  def blurb(locale)
    localed_header(locale) ? localed_header(locale).blurb : ''
  end

  def image(locale)
    localed_header(locale) ? localed_header(locale).image : ''
  end

  def image_thumb(locale)
    localed_header(locale) ? localed_header(locale).image.thumb.url : ''
  end

  def body(locale)
    localed_content(locale) ? localed_content(locale).body : ''
  end

  # Set 2 decimal places
  def goal_amount_z
    to_currency_z(goal_amount, :usd)
  end

  def goal_amount_f
    to_currency_f(goal_amount, :usd)
  end

  def main_language
    pl = project_locales.find_by(is_main: true)
    if pl.blank?
      return Language.find_by(code: :en)
    else
      return pl.language
    end
  end

  def languages
    project_locales_sorted.pluck('languages.name_en')
  end

  def project_locales_sorted
    project_locales.joins(:language).order('languages.sort_order')
  end

  def get_or_new_locale(language_id)
    pl = project_locales.find { |r| r.language_id == language_id }
    pl = project_locales.langed(language_id) if pl.blank?
    pl = project_locales.build(language_id: language_id) if pl.blank?
    pl
  end

  def get_or_new_header(language_id)
    ph = project_headers.find { |r| r.language_id == language_id }
    ph = project_headers.langed(language_id) if ph.blank?
    ph = project_headers.build(language_id: language_id) if ph.blank?
    ph
  end

  def get_or_new_content(language_id)
    pc = project_contents.find { |r| r.language_id == language_id }
    pc = project_contents.langed(language_id) if pc.blank?
    pc = project_contents.build(language_id: language_id) if pc.blank?
    pc
  end

  def pledges_to_pay
    Pledge.to_pay.joins(:reward).where('rewards.project_id = ?', id).merge(Reward.sorted).order(:pledged_at)
  end

  # Pledges in status after preapproved (include pay backed and errors)
  def backed_pledges
    Pledge.joins(:pledge_payment).joins(:reward).where('pledge_payments.status >= ?', Divs::PledgePaymentStatus::PREAPPROVED.to_i).where('rewards.project_id = ?', id).merge(Reward.sorted).order(:pledged_at)
  end

  def pledges
    Pledge.joins(:reward).where('rewards.project_id = ?', id).merge(Reward.sorted).order(:pledged_at)
  end

  def first_post?
    return true if code.blank?
    !Project.where.not(id: id).exists?(code: code)
  end

  def discard!
    update_attribute(:status_div, Divs::ProjectStatus::DISCARDED)
  end

  def apply!
    update_attribute(:status_div, Divs::ProjectStatus::APPLIED)
  end

  def remand!
    update_attribute(:status_div, Divs::ProjectStatus::REMANDED)
  end

  def approve!
    if applied_begin_date > Time.now
      begin_date = applied_begin_date
    else
      late_days = ((Time.now - applied_begin_date)/(24*3600)).ceil
      begin_date = applied_begin_date + late_days*24*3600
    end

    active_records = Project.where.not(id: id)
    .where(code: code, status_div: Divs::ProjectStatus::ACTIVE)

    active_records.each do |r|
      if r.view_begin_at > Time.now
        r.update_attributes(view_begin_at: begin_date, view_end_at: begin_date)
      elsif r.view_end_at > Time.now
        r.update_attribute(:view_end_at, begin_date)
      end
    end

    if active_records.size > 0
      update_attributes(status_div: Divs::ProjectStatus::ACTIVE,
                        view_begin_at: begin_date,
                        view_end_at: END_OF_THE_WORLD)
    else
      update_attributes(status_div: Divs::ProjectStatus::ACTIVE,
                        begin_at: begin_date,
                        end_at: begin_date + duration_days.days,
                        view_begin_at: begin_date,
                        view_end_at: END_OF_THE_WORLD)
    end
  end

  def resume!
    update_attribute(:status_div, Divs::ProjectStatus::ACTIVE)
  end

  def suspend!
    update_attribute(:status_div, Divs::ProjectStatus::SUSPENDED)
  end

  def drop!
    update_attribute(:status_div, Divs::ProjectStatus::DROPPED)
  end

  def replicate
    replica = dup
    replica.view_begin_at = nil
    replica.view_end_at = nil
    replica.applied_begin_date = Date.today

    project_locales.each { |ph| replica.project_locales << ph.replicate }
    project_headers.each { |ph| replica.project_headers << ph.replicate }
    project_contents.each { |pc| replica.project_contents << pc.replicate }
    rewards.each { |r| replica.rewards << r.replicate }

    replica
  end

  # validate if rewards exist
  def rewards_exist
    if rewards.size == 0
      errors[:base] << 'At lease 1 reward is required.'
      return
    end
    true
  end

  def summary
    if project_pledge_summary.present?
      project_pledge_summary
    else
      build_project_pledge_summary(funded_count: 0, funded_amount: 0)
    end
  end

  def days_to_go
    return 0 if end_at.blank?

    (end_at.to_date - Date.today).to_i
  end

  def finished?
    return false if end_at.blank?
    end_at < Time.now
  end

  def self.search_by_category(id)
    active.where(category_id: id)
  end

  def self.search_by_term(term)
    active.joins(:project_headers).where('project_headers.title LIKE ?', "%#{escape_like(term)}%")
  end

  def self.escape_like(string)
    string.gsub(/[\\%_]/){|m| "\\#{m}"}
  end

  def self.posted_by(user_id)
    statuses = []
    statuses << Divs::ProjectStatus::ACTIVE.value
    statuses << Divs::ProjectStatus::DRAFT.value
    statuses << Divs::ProjectStatus::APPLIED.value
    statuses << Divs::ProjectStatus::REMANDED.value

    where(user_id: user_id).where(status_div: statuses).order(:status_div)
  end

  def self.backed_by(user_id)
    rewards_codes = Pledge.joins(:pledge_payment).where('pledge_payments.status >= 3').where(user_id: user_id).pluck(:reward_code)
    active.joins(:rewards).where('rewards.code': rewards_codes)
  end

  def self.favorites
    favorites = Hash.new
    Category.sorted.each do |c|
      favorites[c.id] = Project.active.find_by(category_id: c)
    end
    favorites
  end

  private

  def main_language_is_used
    if project_locales.size > 0
      errors.add(:main_language_id, 'must be selected from used languages') if project_locales.find(&:is_main).blank?
    end
  end

  def localed_header(locale)
    ph = project_headers.localed(locale)
    ph = project_headers.find_by(language_id: main_language.id) if ph.blank?
    ph
  end

  def localed_content(locale)
    pc = project_contents.localed(locale)
    pc = project_contents.find_by(language_id: main_language.id) if pc.blank?
    pc
  end
end
