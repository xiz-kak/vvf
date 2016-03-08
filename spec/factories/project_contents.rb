FactoryGirl.define do
  factory :project_content_en, class: :project_content do
    project nil
    language Language.coded(:en)
    body "MyText"
  end

  factory :project_content_vi, class: :project_content do
    project nil
    language Language.coded(:vi)
    body "MyText"
  end

  factory :project_content_ja, class: :project_content do
    project nil
    language Language.coded(:ja)
    body "MyText"
  end
end
