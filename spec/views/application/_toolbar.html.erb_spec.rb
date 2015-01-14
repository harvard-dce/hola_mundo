describe 'application/_toolbar.html.erb' do
  context 'when viewed by a student' do
    it 'does not show the course settings' do
      render 'application/toolbar', current_user: student

      expect(rendered).not_to have_link(t('courses.settings'))
    end
  end

  context 'when viewed by an instructor' do
    it 'does show the course settings' do
      render 'application/toolbar', current_user: instructor

      expect(rendered).to have_link(t('courses.settings'))
    end
  end

  def student
    build(:dce_lti_user, roles: ['student'])
  end

  def instructor
    build(:dce_lti_user, roles: ['instructor'])
  end
end
