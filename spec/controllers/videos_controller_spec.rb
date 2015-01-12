describe VideosController do
  include LtiControllerHelpers
  before do
    stub_course_session_variables
  end

  context 'unauthenticated visits' do
    context '#index' do
      it 'are redirected to the invalid session path' do
        get :index

        expect(response).to redirect_to(DceLti::Engine.routes.url_helpers.invalid_sessions_path)
      end
    end

    context '#new' do
      it 'are redirected to the invalid session path' do
        get :new

        expect(response).to redirect_to(DceLti::Engine.routes.url_helpers.invalid_sessions_path)
      end
    end

    context '#create' do
      it 'are redirected to the invalid session path' do
        post :new, { videos: {} }

        expect(response).to redirect_to(DceLti::Engine.routes.url_helpers.invalid_sessions_path)
      end
    end
  end

  context '#index' do
    it 'auto creates a course on successful launch and saves the title' do
      resource_link_id = 'an awesome course id'
      context_title = 'A course (AKA context) title'
      session[:resource_link_id] = resource_link_id
      session[:context_title] = context_title

      course = build(:course, id: 1000)
      allow(course).to receive_messages(:title= => true , new_record?: true, save!: true)
      allow(Course).to receive(:find_or_initialize_by).and_return(course)
      stub_user

      get :index

      expect(Course).to have_received(:find_or_initialize_by).with(resource_link_id: resource_link_id)
      expect(course).to have_received(:title=).with(context_title)
      expect(course).to have_received(:save!)
    end

    it 'visits are successful' do
      stub_user

      get :index

      expect(response).to be_successful
    end

    it 'finds videos for a visitor' do
      course = build(:course, id: 10000, resource_link_id: 'sdf')
      allow(Course).to receive(:find_or_initialize_by).and_return(course)
      user = stub_user

      resource_link_scoped_videos_double = double('Found vids by resource_link_id')
      allow(resource_link_scoped_videos_double).to receive(:find_by)
      allow(Video).to receive(:by_course_id).and_return(
        resource_link_scoped_videos_double
      )

      get :index

      expect(Video).to have_received(:by_course_id).with(
        course.id
      )
      expect(resource_link_scoped_videos_double).to have_received(:find_by).
        with(dce_lti_user_id: user.id)
    end
  end

  context '#create' do
    it 'uses CourseUserVideoCreator to create a new video for a user' do
      course_id = 1000
      youtube_id = 'abcdefg'
      user = stub_user
      course = build(:course, id: course_id)
      allow(course).to receive(:new_record?).and_return(false)

      allow(Course).to receive(:find_or_initialize_by).and_return(course)
      allow(CourseUserVideoCreator).to receive(:create)

      post :create, { video: { youtube_id: youtube_id } }

      expect(CourseUserVideoCreator).to have_received(:create).with(
        youtube_id: youtube_id,
        dce_lti_user_id: user.id,
        course_id: course_id
      )
      expect(response).to be_successful
    end

    it 'returns a logical failure code when creating a video fails' do
      stub_user
      allow(CourseUserVideoCreator).to receive(:create).and_raise

      post :create, { video: {  } }

      expect(response.status).to eq 422
    end
  end
end
