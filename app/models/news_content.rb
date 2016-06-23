# == Schema Information
#
# Table name: news_contents
#
#  id          :integer          not null, primary key
#  news_id     :integer
#  language_id :integer
#  title       :string
#  body        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_news_contents_on_language_id  (language_id)
#  index_news_contents_on_news_id      (news_id)
#
# Foreign Keys
#
#  fk_rails_4f06a8cef1  (news_id => news.id)
#  fk_rails_733b5e2c29  (language_id => languages.id)
#

class NewsContent < ActiveRecord::Base
  belongs_to :news, inverse_of: :news_contents
  belongs_to :language

  validates :news, presence: true
  validates :language, presence: true, uniqueness: { scope: :news_id }

  include LocaleBase
end
