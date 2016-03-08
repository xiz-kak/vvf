FactoryGirl.define do
  factory :reward_content_en, class: :reward_content do
    reward nil
    language Language.coded(:en)
    title "MyString"
    image_path "MyString"
    description "MyText"
  end

  factory :reward_content_vi, class: :reward_content do
    reward nil
    language Language.coded(:vi)
    title "MyString"
    image_path "MyString"
    description "MyText"
  end

  factory :reward_content_ja, class: :reward_content do
    reward nil
    language Language.coded(:ja)
    title "MyString"
    image_path "MyString"
    description "MyText"
  end
end
