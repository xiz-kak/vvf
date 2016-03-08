FactoryGirl.define do
  factory :category_locale_en do
    association :category, factory: :category
    name "MyString"
    language_id Language.find_by(code: :en).id
  end

  factory :category_locale_vi do
    association :category, factory: :category
    name "MyString"
    language_id Language.find_by(code: :vi).id
  end

  factory :category_locale_ja do
    association :category, factory: :category
    name "MyString"
    language_id Language.find_by(code: :ja).id
  end
end
