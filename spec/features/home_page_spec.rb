feature 'A user visits the homepage' do
  before do
    ENV['FAKE_USER_ID'] = create(:dce_lti_user, :student).id.to_s
    page.set_rack_session(resource_link_id: 'a resource link id')
  end

  scenario 'and sees that they can upload a video' do
    visit '/'

    expect(page).to have_link(t('videos.new'))
  end
end

feature 'A anonymous user visits the homepage' do
  scenario 'and sees a notice about an invalid session' do
    visit '/'

    expect(page).to have_content(/invalid session/i)
  end
end
