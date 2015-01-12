feature 'An instructor manages a course' do
  before do
    ENV['FAKE_USER_ID'] = create(:dce_lti_user, :instructor).id.to_s
    page.set_rack_session(resource_link_id: 'a resource link id')
  end

  scenario 'and can set a course to allow unreviewed videos' do
    visit '/'

    click_on t('courses.unrequire_review_for_course')

    expect(page).to have_link(t('courses.require_review_for_course'))
  end
end
