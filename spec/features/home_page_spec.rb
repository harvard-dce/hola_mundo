feature 'A user visits the homepage' do
  before do
    ENV['FAKE_USER_ID'] = user.id.to_s
  end

  scenario 'and sees that they can upload a video' do
    visit '/'

    expect(page).to have_link('Upload a video')
  end

  def user
    @user ||= DceLti::User.create!(lti_user_id: 'foobar')
  end
end
