FactoryGirl.define do
  factory :dce_lti_user, class: DceLti::User do
    sequence(:lti_user_id) { |n| "user_id-#{n}" }
    trait :student do
      roles ['student']
    end
    trait :instructor do
      roles ['instructor']
    end
  end

  factory :course do
    sequence(:resource_link_id) { |n| "resource_link_id_#{n}" }
    title 'Course title'
    created_at { Time.now }
  end

  factory :video do
    sequence(:youtube_id) { |n| "youtube-id-#{n}" }
    dce_lti_user
    course
    created_at { Time.now }
  end
end
