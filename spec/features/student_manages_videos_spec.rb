feature 'A user manages upload videos' do
  context 'and has created a video' do
    before do
      course = create(:course)
      user = create(:dce_lti_user)
      ENV['FAKE_USER_ID'] = user.id.to_s
      page.set_rack_session(resource_link_id: course.resource_link_id)
      page.set_rack_session(roles: ['learner'])
      create(:video, dce_lti_user: user, course: course)
    end

    scenario 'then they can view the video' do
      visit '/'
      click_on t('videos.view_my_video')

      expect(page).to have_css('#my_video_player')
    end
  end

  context 'and does not have a video' do
    before do
      ENV['FAKE_USER_ID'] = create(:dce_lti_user).id.to_s
      page.set_rack_session(resource_link_id: 'a resource link id')
      page.set_rack_session(roles: ['learner'])
    end

    scenario 'then they are prompted to create a video' do
      visit '/'

      expect(page).to have_content(t('videos.review_required_but_none_yet'))
    end

    scenario 'they can create a video' do
      visit '/'
      click_on t('videos.view_my_video')

      expect(page).to have_content(t('videos.none_uploaded_yet'))
    end
  end
end
