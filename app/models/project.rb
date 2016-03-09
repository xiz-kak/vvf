# == Schema Information
#
# Table name: projects
#
#  id            :integer          not null, primary key
#  category_id   :integer
#  goal_amount   :float
#  duration_days :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_projects_on_category_id  (category_id)
#
# Foreign Keys
#
#  fk_rails_2ad2693164  (category_id => categories.id)
#

class Project < ActiveRecord::Base
  belongs_to :category
  has_many :project_locales, dependent: :destroy, inverse_of: :project
  has_many :project_headers, dependent: :destroy, inverse_of: :project
  has_many :project_contents, dependent: :destroy, inverse_of: :project
  has_many :rewards, -> { order(:price, :count, :id) }, dependent: :destroy, inverse_of: :project
  accepts_nested_attributes_for :project_locales, allow_destroy: true
  accepts_nested_attributes_for :project_headers, allow_destroy: true
  accepts_nested_attributes_for :project_contents, allow_destroy: true
  accepts_nested_attributes_for :rewards, allow_destroy: true

  validates :category, presence: true
  validates :goal_amount, presence: true
  validates :duration_days, presence: true
  validate :main_language_is_used

  def main_language
    pl = project_locales.find_by(is_main: true)
    if pl.blank?
      return Language.find_by(code: :en)
    else
      return pl.language
    end
  end

  # Set 2 decimal places
  def goal_amount_z
    ApplicationController.helpers.number_with_precision(goal_amount, precision: 2)
  end

  def project_locales_sorted
    self.project_locales.joins(:language).order('languages.sort_order')
  end

  def get_or_new_locale(locale)
    pl = project_locales.find { |r| r.language_id == Language.locale_to_lang(locale) }
    pl = project_locales.localed(locale) if pl.blank?
    pl = project_locales.build(language_id: Language.locale_to_lang(locale)) if pl.blank?
    pl
  end

  def get_or_new_header(locale)
    ph = project_headers.find { |r| r.language_id == Language.locale_to_lang(locale) }
    ph = project_headers.localed(locale) if ph.blank?
    ph = project_headers.build(language_id: Language.locale_to_lang(locale)) if ph.blank?
    ph
  end

  def get_or_new_content(locale)
    pc = project_contents.find { |r| r.language_id == Language.locale_to_lang(locale) }
    pc = project_contents.localed(locale) if pc.blank?
    pc = project_contents.build(language_id: Language.locale_to_lang(locale)) if pc.blank?
    pc
  end

  private

  def main_language_is_used
    if project_locales.count > 0
      errors.add(:main_language_id, 'must be selected from used languages') if project_locales.find(&:is_main).blank?
    end
  end
end
