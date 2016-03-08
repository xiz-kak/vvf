# == Schema Information
#
# Table name: project_headers
#
#  id          :integer          not null, primary key
#  project_id  :integer
#  language_id :integer
#  title       :string
#  image_path  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_project_headers_on_language_id  (language_id)
#  index_project_headers_on_project_id   (project_id)
#
# Foreign Keys
#
#  fk_rails_04851283e9  (language_id => languages.id)
#  fk_rails_77b9a6f12c  (project_id => projects.id)
#

class ProjectHeader < ActiveRecord::Base
  belongs_to :project
  belongs_to :language

  include LocaleBase
end
