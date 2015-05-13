class CourseUserVideoCreator
  def self.create(youtube_id:, dce_lti_user_id:, course_id:, description:, source:)
    Video.by_course_id(course_id).where(dce_lti_user_id: dce_lti_user_id).destroy_all
    Video.create!(
      description: description,
      dce_lti_user_id: dce_lti_user_id,
      course_id: course_id,
      youtube_id:  youtube_id,
      source: source
    )
  end
end
