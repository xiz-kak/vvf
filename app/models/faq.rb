# == Schema Information
#
# Table name: faqs
#
#  id               :integer          not null, primary key
#  sort_order       :integer
#  faq_category_div :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Faq < ActiveRecord::Base
  include SortableBase

  has_many :faq_contents, dependent: :destroy, inverse_of: :faq
  accepts_nested_attributes_for :faq_contents, allow_destroy: true

  bind_inum :faq_category_div, Divs::FaqCategory

  def question(locale)
    faq_contents.localed(locale).question
  end

  def answer(locale)
    faq_contents.localed(locale).answer
  end

  def answer_detail(locale)
    faq_contents.localed(locale).answer_detail
  end

  def get_or_new_content(language_id)
    fc = faq_contents.find { |r| r.language_id == language_id }
    fc = faq_contents.langed(language_id) if fc.blank?
    fc = faq_contents.build(language_id: language_id) if fc.blank?
    fc
  end
end
