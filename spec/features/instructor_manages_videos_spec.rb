feature 'An instructor manages a video' do
  before do
    ENV['FAKE_USER_ID'] = create(:dce_lti_user).id.to_s
    page.set_rack_session(roles: ['instructor'])
    page.set_rack_session(resource_link_id: 'a resource link id')
    visit '/'
  end

  scenario 'and can delete it' do
    video = create(:video, course: Course.first)

    visit '/'

    within("#video_#{video.id}") do
      click_on(t('videos.destroy'))
    end

    expect{Video.find(video.id)}.to raise_error
  end

  scenario 'and can update it' do
    video = create(:video, course: Course.first, approved: false)

    visit '/'

    within("#video_#{video.id}") do
      click_on(t('videos.approve'))
    end

    video.reload
    expect(video).to be_approved
  end
end
