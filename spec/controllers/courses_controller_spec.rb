describe CoursesController do
  include LtiControllerHelpers
  before do
    stub_course_session_variables
  end

  context '#update' do
    context 'unauthenticated users' do
      it 'redirects to the session denied path' do
        patch :update, {}

        expect(response).to redirect_to(DceLti::Engine.routes.url_helpers.invalid_sessions_path)
      end
    end

    context 'student users' do
      it 'redirects to the root_path' do
        stub_user
        patch :update, {}

        expect(response).to redirect_to(root_path)
      end
    end

    context 'instructors' do
      it 'can update a course' do
        user = stub_user
        user.roles = ['instructor']
        course = double(:course).as_null_object

        allow(Course).to receive(:find_or_initialize_by).and_return(course)

        patch :update, {}

        expect(response).to redirect_to(edit_course_path)
        expect(flash[:notice]).to include(t('courses.updated'))
      end
    end
  end
end
