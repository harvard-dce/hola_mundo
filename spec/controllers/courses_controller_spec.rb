describe CoursesController do
  include LtiControllerHelpers
  before do
    stub_course_session_variables
  end

  context '#review_toggle' do
    context 'unauthenticated users' do
      it 'redirects to the session denied path' do
        post :review_toggle, {}
        expect(response).to redirect_to(DceLti::Engine.routes.url_helpers.invalid_sessions_path)
      end
    end

    context 'student users' do
      it 'redirects to the root_path' do
        stub_user
        post :review_toggle, {}

        expect(response).to redirect_to(root_path)
      end

      it 'does not attempt to access coures.toggle_review_required' do
        stub_user
        course = build(:course)
        allow(course).to receive(:toggle_review_required)
        allow(Course).to receive(:find_or_initialize_by).and_return(course)

        post :review_toggle, {}

        expect(response).to redirect_to(root_path)
        expect(course).to_not have_received(:toggle_review_required)
      end
    end

    context 'instructors' do
      it 'can toggle a review on a course' do
        stub_user do |user|
          user.roles = ['instructor']
        end
        course = build(:course)

        allow(course).to receive_messages(
          :save! => true,
          toggle_review_required: true,
          :new_record? => false
        )
        allow(Course).to receive(:find_or_initialize_by).and_return(course)

        post :review_toggle, {}

        expect(course).to have_received(:toggle_review_required)
        expect(course).to have_received(:save!)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to include(t('courses.toggled'))
      end
    end
  end
end
