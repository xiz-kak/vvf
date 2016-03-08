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
  has_many :project_headers, dependent: :destroy
  has_many :project_contents, dependent: :destroy
  has_many :rewards, -> { order(:price, :count, :id) }
  accepts_nested_attributes_for :project_locales, allow_destroy: true
  accepts_nested_attributes_for :project_headers, allow_destroy: true
  accepts_nested_attributes_for :project_contents, allow_destroy: true
  accepts_nested_attributes_for :rewards, allow_destroy: true

  def main_language
    pl = self.project_locales.find_by(is_main: true)
    if pl.blank?
      return Language.find_by(code: :en)
    else
      return pl.language
    end
  end

  def goal_amount_f
    ApplicationController.helpers.number_with_precision(self.goal_amount, precision: 2)
  end

  def get_or_new_header(locale)
    header = self.project_headers.localed(locale)
    header = self.project_headers.build(language_id: Language.locale_to_lang(locale)) if header.blank?
    header
  end

  def get_or_new_content(locale)
    content = self.project_contents.localed(locale)
    content = self.project_contents.build(language_id: Language.locale_to_lang(locale)) if content.blank?
    content
  end
end
