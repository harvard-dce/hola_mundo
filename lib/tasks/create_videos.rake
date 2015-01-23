if Rails.env.development?
  require "factory_girl"

  namespace :hola_mundo do
    desc "Add fake videos to a course"
    task create_videos: :environment do
      include FactoryGirl::Syntax::Methods
      course = if ENV['COURSE_ID']
                 Course.find(ENV['COURSE_ID'])
               else
                 Course.last
               end

      exit unless course.present?

      %w|YxgsxaFWWHQ
     orybDrUj4vA
     Ac9070OIMUg
     8DNtsjB7L_I
     PukSDm0RD2E
     wRc630BSTIg
     l8XOZJkozfI
     odmKYVm72LU
     7Pq-S557XQU
     0dU4IMex4FU|.each do |youtube_id|
        user = create(:dce_lti_user)
        Video.find_or_initialize_by(youtube_id: youtube_id).tap do |video|
          video.course = course
          video.dce_lti_user = user
        end.save!
      end
    end
  end
end
