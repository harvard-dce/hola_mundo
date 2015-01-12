class CourseUserVideoCreator
  def self.create(youtube_id:, dce_lti_user_id:, course_id:)
    Video.by_course_id(course_id).find_or_initialize_by(
      dce_lti_user_id: dce_lti_user_id
    ).tap do |video|
      video.youtube_id = youtube_id
    end.save!
  end
end
