FactoryGirl.define do
  factory :reward do
    association :project, factory: :project
    price 1300.5
    count 1000
    reward_contents { [build(:reward_content_en), build(:reward_content_vi)] }
  end
end
