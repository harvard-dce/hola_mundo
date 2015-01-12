describe Video do
  it { should belong_to(:course) }
  it { should validate_presence_of(:dce_lti_user_id) }
  it { should have_db_index(:dce_lti_user_id) }

  it { should validate_presence_of(:youtube_id) }
  it { should ensure_length_of(:youtube_id).is_at_most(20) }

  it { should validate_presence_of(:course_id) }

  it 'validates uniqueness of a user video in a course' do
    video = build(:video)
    expect(video).to validate_uniqueness_of(:dce_lti_user_id).scoped_to(:course_id)
  end

  it { should have_db_index([:course_id, :dce_lti_user_id]).unique(true) }

  context '#approved' do
    it 'is set to false after creation if a course requires review' do
      course = create(:course, review_required: true)
      video = build(:video, course: course)

      video.save!

      expect(video.approved).to be false
    end

    it 'is set to true after creation if a course does not require review' do
      course = create(:course, review_required: false)
      video = build(:video, course: course)

      video.save!

      expect(video.approved).to be true
    end

    it 'is reset if the course review status changes on next save' do
      course = create(:course, review_required: true)

      video = create(:video, course: course)

      expect(video.approved).to be false

      course.review_required = false
      course.save

      video.reload
      video.save

      expect(video.approved).to be true
    end
  end
end
