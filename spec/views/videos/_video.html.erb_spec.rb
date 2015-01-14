describe 'videos/_video.html.erb' do
  context 'displays meaningful info about approval state' do
    before do
      allow(view).to receive(:current_user).and_return(build(:dce_lti_user, :instructor))
    end

    it 'when false' do
      video = build(:video, approved: false, id: 10)

      render 'videos/video', video: video

      expect(rendered).to have_css('.approved.badge.false')
      expect(rendered).to have_link(t('videos.approve'))
    end

    it 'when true' do
      video = build(:video, approved: true, id: 10)

      render 'videos/video', video: video

      expect(rendered).to have_css('.approved.badge.true')
      expect(rendered).to have_link(t('videos.disapprove'))
    end
  end

  context 'admin controls' do
    it 'are displayed to instructors' do
      user = build(:dce_lti_user, :instructor)
      allow(view).to receive(:current_user).and_return(user)

      render 'videos/video', video: build(:video, dce_lti_user: user, id: 10)

      expect(rendered).to have_css('.edit_video_menu')
    end

    it 'are not displayed to non-instructors' do
      user = build(:dce_lti_user, :student)
      allow(view).to receive(:current_user).and_return(user)

      render 'videos/video', video: build(:video, dce_lti_user: user)

      expect(rendered).not_to have_css('.edit_video_menu')
    end
  end
end
