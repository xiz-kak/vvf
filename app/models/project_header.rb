# == Schema Information
#
# Table name: project_headers
#
#  id          :integer          not null, primary key
#  project_id  :integer
#  language_id :integer
#  title       :string
#  image       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  blurb       :string
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
  belongs_to :project, inverse_of: :project_headers
  belongs_to :language

  validates :project, presence: true
  validates :language, presence: true, uniqueness: { scope: :project_id }
  validates :title, presence: true
  validates :blurb, presence: true, length: { maximum: 150 }
  validates :image, presence: true

  mount_uploader :image, ImageUploader

  include LocaleBase

  def replicate
    replica = dup
    replica.project_id = nil
    replica.image = image
    replica
  end
end
