feature 'LTI Session negotiation fails possibly due to third party cookies' do
  scenario 'a relevant message should be displayed' do
    visit '/'

    expect(page).to have_content /enabling third-party cookies/i
  end
end
