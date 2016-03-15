FactoryGirl.define do
  factory :reward do
    association :project, factory: :project_wo_validation
    price 1300.5
    count 1000
    reward_contents { [build(:reward_content_en), build(:reward_content_vi)] }

    factory :reward_wo_validation do
      to_create {|instance| instance.save(validate: false) }
    end
  end
end
