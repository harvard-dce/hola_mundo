describe 'videos/_video.html.erb' do
  include ViewAuthHelpers
  include LtiControllerHelpers

  context 'displays meaningful info about approval state' do
    before do
      stub_instructor_role
      allow(view).to receive(:current_user).and_return(build(:dce_lti_user))
    end

    it 'when false' do
      course = stub_course
      course.review_required = true

      video = build(:video, approved: false, course: course, id: 10)

      render 'videos/video', video: video

      expect(rendered).to have_css('.approved.badge.false')
      expect(rendered).to have_link(t('videos.approve'))
    end

    it 'when true' do
      course = stub_course
      course.review_required = true

      video = build(:video, approved: true, course: course, id: 10)

      render 'videos/video', video: video

      expect(rendered).to have_css('.approved.badge.true')
      expect(rendered).to have_link(t('videos.disapprove'))
    end
  end

  context 'admin controls' do
    it 'are displayed to instructors' do
      stub_instructor_role
      user = build(:dce_lti_user)
      allow(view).to receive(:current_user).and_return(user)

      render 'videos/video', video: build(:video, dce_lti_user: user, id: 10)

      expect(rendered).to have_css('.edit_video_menu')
    end

    it 'are not displayed to non-instructors and non-owners' do
      stub_learner_role
      user = build(:dce_lti_user)
      allow(view).to receive(:current_user).and_return(user)

      render 'videos/video', video: build(:video)

      expect(rendered).not_to have_css('.edit_video_menu')
    end
    it 'are displayed to non-instructors that own the video' do
      stub_learner_role
      user = build(:dce_lti_user)
      allow(view).to receive(:current_user).and_return(user)

      render 'videos/video', video: build(:video, id: 100, dce_lti_user: user)

      expect(rendered).to have_css('.edit_video_menu')
    end
  end
end
