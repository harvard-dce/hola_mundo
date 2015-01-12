describe 'application/_toolbar.html.erb' do
  context 'when viewed by a student' do
    it 'does not show the course video review toggle for students' do
      render 'application/toolbar', current_user: student

      expect(rendered).not_to have_css('.course_review_toggle')
    end
  end

  context 'when viewed by an instructor' do
    it 'shows that a course requires review' do
      course = build(:course, review_required: true)
      render 'application/toolbar', current_user: instructor, course: course

      expect(rendered).to have_link(t('courses.unrequire_review_for_course'))
    end

    it 'shows that a course does not require review' do
      course = build(:course, review_required: false)
      render 'application/toolbar', current_user: instructor, course: course

      expect(rendered).to have_link(t('courses.require_review_for_course'))
    end
  end

  def student
    build(:dce_lti_user, roles: ['student'])
  end

  def instructor
    build(:dce_lti_user, roles: ['instructor'])
  end
end
