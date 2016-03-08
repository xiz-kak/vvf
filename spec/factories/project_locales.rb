FactoryGirl.define do
  factory :project_locale_en, class: :project_locale do
    project nil
    language Language.coded(:en)
    is_main false
  end

  factory :project_locale_vi, class: :project_locale do
    project nil
    language Language.coded(:vi)
    is_main true
  end

  factory :project_locale_ja, class: :project_locale do
    project nil
    language Language.coded(:ja)
    is_main true
  end
end
