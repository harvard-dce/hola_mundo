feature 'An instructor manages a video' do
  before do
    @course = create(:course, resource_link_id: 'a resource_link_id')
    ENV['FAKE_USER_ID'] = create(:dce_lti_user).id.to_s
    page.set_rack_session(roles: ['instructor'])
    page.set_rack_session(resource_link_id: @course.resource_link_id)
    @video = create(:video, course: @course, approved: false)
  end

  scenario 'and can delete it' do
    visit '/'

    within("#video_#{@video.id}") do
      find('.edit_video_menu').click
      click_on(t('videos.destroy'))
    end

    expect(page).not_to have_css("#video_#{@video.id}")
  end

  scenario 'and can update it' do
    visit '/'

    within("#video_#{@video.id}") do
      find('.edit_video_menu').click
      click_on(t('videos.approve'))
    end

    within("#video_#{@video.id}") do
      expect(page).to have_css('.approved.true')
    end
  end
end
