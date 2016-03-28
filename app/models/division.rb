# == Schema Information
#
# Table name: divisions
#
#  id          :integer          not null, primary key
#  code        :integer
#  val         :integer
#  sort_order  :integer
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_divisions_on_code_and_val  (code,val) UNIQUE
#

class Division < ActiveRecord::Base
  has_many :division_locales, dependent: :destroy
  has_many :projects, inverse_of: :statu
  has_many :rewards, inverse_of: :ships_to
  has_many :pledge_payments, inverse_of: :payment_method

  accepts_nested_attributes_for :division_locales, allow_destroy: true

  validates :code, presence: true
  validates :val, presence: true, uniqueness: { scope: :code }

  def name(locale)
    division_locales.localed(locale).name
  end

  def get_or_new_locale(language_id)
    dl = division_locales.find { |r| r.language_id == language_id }
    dl = division_locales.langed(language_id) if dl.blank?
    dl = division_locales.build(language_id: language_id) if dl.blank?
    dl
  end

  CODES = { project_status: 2, reward_ships_to: 5, pledge_payment_method: 7 }
  VALS = { project_status: { draft: 1, applied: 2, active: 5, closed: 9 },
           reward_ships_to: { no_shipping: 1, certain_countries: 2, anywhere_in_the_world: 3 },
           pledge_payment_method: { wallet: 1 },
         }

  def self.code(code)
    CODES[code].to_i
  end

  def self.val(code, val)
    VALS[code][val].to_i
  end

  def self.div(code, val)
    c = CODES[code]
    v = VALS[code][val]
    Division.where(code: c, val: v).first
  end

  def self.find_by_code(code)
    c = CODES[code]
    Division.where(code: c)
  end
end
