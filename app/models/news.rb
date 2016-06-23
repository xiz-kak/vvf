# == Schema Information
#
# Table name: news
#
#  id         :integer          not null, primary key
#  begin_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class News < ActiveRecord::Base
  has_many :news_contents, dependent: :destroy, inverse_of: :news
  accepts_nested_attributes_for :news_contents, allow_destroy: true

  validates :begin_at, presence: true

  scope :sorted, -> { order(begin_at: :desc ) }
  scope :active, -> { where('begin_at <= ?', Time.now) }

  def title(locale)
    news_contents.localed(locale).title
  end

  def body(locale)
    news_contents.localed(locale).body
  end

  def get_or_new_content(language_id)
    c = news_contents.find { |r| r.language_id == language_id }
    c = news_contents.langed(language_id) if c.blank?
    c = news_contents.build(language_id: language_id) if c.blank?
    c
  end
end
