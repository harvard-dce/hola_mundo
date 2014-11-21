feature 'Canvas-specific LTI configuration' do
  scenario 'emits XML that adds this tool to the course menu' do
    visit '/lti/configs.xml'

    xml = Nokogiri::XML(page.html)

    expect(xml.css('[name="course_navigation"]')).not_to be_empty
  end
end
