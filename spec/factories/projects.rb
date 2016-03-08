FactoryGirl.define do
  factory :project do
    association :category, factory: :category
    goal_amount 1300.5
    duration_days 30
    project_locales { [build(:project_locale_en), build(:project_locale_vi)] }
    project_headers { [build(:project_header_en), build(:project_header_vi)] }
    project_contents { [build(:project_content_en), build(:project_content_vi)] }
  end
end
