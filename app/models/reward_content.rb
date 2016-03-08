# == Schema Information
#
# Table name: reward_contents
#
#  id          :integer          not null, primary key
#  reward_id   :integer
#  language_id :integer
#  title       :string
#  image_path  :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_reward_contents_on_language_id  (language_id)
#  index_reward_contents_on_reward_id    (reward_id)
#
# Foreign Keys
#
#  fk_rails_2cb5c44853  (language_id => languages.id)
#  fk_rails_60ff93b263  (reward_id => rewards.id)
#

class RewardContent < ActiveRecord::Base
  belongs_to :reward, inverse_of: :reward_contents
  belongs_to :language

  validates :reward, presence: true
  validates :language, presence: true, uniqueness: { scope: :reward_id }
  validates :title, presence: true
  validates :image_path, presence: true
  validates :description, presence: true
end
