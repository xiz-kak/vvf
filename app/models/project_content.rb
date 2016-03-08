# == Schema Information
#
# Table name: project_contents
#
#  id          :integer          not null, primary key
#  project_id  :integer
#  language_id :integer
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_project_contents_on_language_id  (language_id)
#  index_project_contents_on_project_id   (project_id)
#
# Foreign Keys
#
#  fk_rails_305e6d8bf1  (project_id => projects.id)
#  fk_rails_4361a57cbb  (language_id => languages.id)
#

class ProjectContent < ActiveRecord::Base
  belongs_to :project, inverse_of: :project_contents
  belongs_to :language

  validates :project, presence: true
  validates :language, presence: true, uniqueness: { scope: :project_id }
  validates :body, presence: true

  include LocaleBase
end
