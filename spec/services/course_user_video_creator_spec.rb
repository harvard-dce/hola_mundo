describe CourseUserVideoCreator do
  it 'creates or initializes a video model associated with a user' do
    youtube_id = 'abcdefg'
    course_id = 1000
    user = DceLti::User.new
    allow(user).to receive(:id).and_return(1000)
    video = Video.new

    video_finder_double = double('Found videos by course_id')
    allow(video_finder_double).to receive(:find_or_initialize_by).and_return(video)

    allow(Video).to receive(:by_course_id).and_return(video_finder_double)
    allow(video).to receive(:save!)

    described_class.create(
      youtube_id: youtube_id,
      dce_lti_user_id: user.id,
      course_id: course_id
    )

    expect(Video).to have_received(:by_course_id).with(course_id)
    expect(video_finder_double).to have_received(:find_or_initialize_by).with(
      dce_lti_user_id: user.id
    )
    expect(video.youtube_id).to eq youtube_id
    expect(video).to have_received(:save!)
  end
end
