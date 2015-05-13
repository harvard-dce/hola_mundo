feature 'An instructor manages a course' do
  before do
    ENV['FAKE_USER_ID'] = create(:dce_lti_user).id.to_s
    page.set_rack_session(resource_link_id: 'a resource link id')
    page.set_rack_session(roles: ['instructor'])
  end

  scenario 'and can set a course to allow unreviewed videos' do
    visit '/'

    click_on t('courses.settings')
    uncheck 'course_review_required'
    click_on('Update Course')

    expect(page).to have_no_checked_field('course_review_required')

    check('course_review_required')
    click_on('Update Course')

    expect(page).to have_checked_field('course_review_required')
  end

  scenario 'and can set contextual language that appears in the interface' do
    visit '/'

    click_on t('courses.settings')
    fill_in 'Welcome message', with: 'A sweet welcome message'
    fill_in 'Upload description', with: 'Hi. do *this* to upload a thing'
    click_on('Update Course')

    click_on t('videos.new')

    expect(page).to have_css('em', text: 'this')

    click_on 'All Contributions'

    expect(page).to have_content('A sweet welcome message')
  end
end
