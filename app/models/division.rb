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

class Division < ActiveRecord::Base
  has_many :division_locales, dependent: :destroy
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
end
