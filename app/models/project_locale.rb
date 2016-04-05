# == Schema Information
#
# Table name: project_locales
#
#  id          :integer          not null, primary key
#  project_id  :integer
#  language_id :integer
#  is_main     :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_project_locales_on_language_id  (language_id)
#  index_project_locales_on_project_id   (project_id)
#
# Foreign Keys
#
#  fk_rails_1f45f85e67  (language_id => languages.id)
#  fk_rails_bc01a4926f  (project_id => projects.id)
#

class ProjectLocale < ActiveRecord::Base
  belongs_to :project, inverse_of: :project_locales
  belongs_to :language

  validates :project, presence: true
  validates :language, presence: true, uniqueness: { scope: :project_id }

  include LocaleBase

  attr_accessor :use_this_language

  def replicate
    replica = dup
    replica.project_id = nil
    replica.use_this_language = "1"
    replica
  end
end
