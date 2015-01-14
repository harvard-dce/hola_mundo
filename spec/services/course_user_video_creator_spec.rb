describe CourseUserVideoCreator do
  it 'allows only one video to exist for a user at a time in a course' do
    youtube_id = 'asdfasdf'
    course = create(:course)
    user = create(:dce_lti_user)

    described_class.create(
      youtube_id: 'fake',
      dce_lti_user_id: user.id,
      course_id: course.id
    )

    described_class.create(
      youtube_id: youtube_id,
      dce_lti_user_id: user.id,
      course_id: course.id
    )
    videos_for_user = Video.by_course_id(course.id).where(dce_lti_user: user.id)

    expect(videos_for_user.count).to eq 1
    expect(videos_for_user.first.youtube_id).to eq youtube_id
  end
end
