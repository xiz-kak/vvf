FactoryGirl.define do
  factory :language do
    trait :en do
      id 1
      code 'en'
      name 'English'
      name_en 'English'
      sort_order 1
    end

    trait :vi do
      id 2
      code 'vi'
      name 'Tiếng Việt'
      name_en 'Vietnamese'
      sort_order 2
    end

    trait :ja do
      id 3
      code 'ja'
      name '日本語'
      name_en 'Japanese'
      sort_order 3
    end
  end
end
