describe 'application/_toolbar.html.erb' do
  include ViewAuthHelpers

  context 'when viewed by a learner' do
    it 'does not show the course settings' do
      stub_learner_role
      render 'application/toolbar', current_user: build(:dce_lti_user)

      expect(rendered).not_to have_link(t('courses.settings'))
    end
  end

  context 'when viewed by an instructor' do
    it 'does show the course settings' do
      stub_instructor_role
      render 'application/toolbar', current_user: build(:dce_lti_user)

      expect(rendered).to have_link(t('courses.settings'))
    end
  end
end
