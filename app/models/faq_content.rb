# == Schema Information
#
# Table name: faq_contents
#
#  id            :integer          not null, primary key
#  faq_id        :integer
#  language_id   :integer
#  question      :string
#  answer        :string
#  answer_detail :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_faq_contents_on_faq_id       (faq_id)
#  index_faq_contents_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_0a7b760434  (language_id => languages.id)
#  fk_rails_6ad1f23cc9  (faq_id => faqs.id)
#

class FaqContent < ActiveRecord::Base
  belongs_to :faq, inverse_of: :faq_contents
  belongs_to :language

  # validates :question, presence: true
  # validates :answer, presence: true
  # validates :answer_detail, presence: true

  include LocaleBase
end
