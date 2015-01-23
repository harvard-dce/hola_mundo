describe CoursesController do
  include LtiControllerHelpers
  before do
    stub_course_session_variables
  end

  context '#edit' do
    context 'unauthenticated users' do
      it 'redirects to the session denied path' do
        get :edit, {}

        expect(response).to redirect_to(DceLti::Engine.routes.url_helpers.invalid_sessions_path)
      end
    end

    context 'learners' do
      it 'redirects to the session denied path' do
        stub_user
        get :edit, {}

        expect(response).to redirect_to(root_path)
      end
    end

    context 'instructors' do
      it 'is successful' do
        user = stub_user
        course = build(:course)
        allow(course).to receive(:user_has_role?).and_return(true)
        allow(Course).to receive(:find_or_initialize_by).and_return(course)

        get :edit, {}

        expect(response).to be_successful
        expect(course).to have_received(:user_has_role?).with(user, 'instructor')
      end
    end
  end

  context '#update' do
    context 'unauthenticated users' do
      it 'redirects to the session denied path' do
        patch :update, {}

        expect(response).to redirect_to(DceLti::Engine.routes.url_helpers.invalid_sessions_path)
      end
    end

    context 'learners' do
      it 'redirects to the root_path' do
        stub_user
        patch :update, {}

        expect(response).to redirect_to(root_path)
      end
    end

    context 'instructors' do
      it 'can update a course' do
        user = stub_user
        course = build(:course)
        allow(course).to receive(:user_has_role?).and_return(true)

        allow(Course).to receive(:find_or_initialize_by).and_return(course)

        patch :update, {}

        expect(response).to redirect_to(edit_course_path)
        expect(flash[:notice]).to include(t('courses.updated'))
        expect(course).to have_received(:user_has_role?).with(user, 'instructor')
      end
    end
  end
end
