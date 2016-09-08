describe VideosController do
  include LtiControllerHelpers

  before do
    stub_course_session_variables
  end

  context 'unauthenticated visits' do
    context '#update' do
      it 'are redirected to the invalid session path' do
        put :update, id: 10

        expect(response).to redirect_to(
          DceLti::Engine.routes.url_helpers.invalid_sessions_path
        )
      end
    end

    context '#destroy' do
      it 'are redirected to the invalid session path' do
        delete :destroy,id: 10

        expect(response).to redirect_to(
          DceLti::Engine.routes.url_helpers.invalid_sessions_path
        )
      end
    end

    context '#index' do
      it 'are redirected to the invalid session path' do
        get :index

        expect(response).to redirect_to(
          DceLti::Engine.routes.url_helpers.invalid_sessions_path
        )
      end
    end

    context '#new' do
      it 'are redirected to the invalid session path' do
        get :new

        expect(response).to redirect_to(
          DceLti::Engine.routes.url_helpers.invalid_sessions_path
        )
      end
    end

    context '#create' do
      it 'are redirected to the invalid session path' do
        post :new, { videos: {} }

        expect(response).to redirect_to(
          DceLti::Engine.routes.url_helpers.invalid_sessions_path
        )
      end
    end
  end

  context '#index' do
    it 'visits are successful' do
      stub_user

      get :index

      expect(response).to be_successful
    end

    it 'uses a filter set' do
      stub_user
      filter_set = double(:filter_set).as_null_object
      allow(controller).to receive(:create_filter_set).and_return(filter_set)

      get :index

      expect(controller).to have_received(:create_filter_set)
    end

    it 'auto creates a course on successful launch and saves the title' do
      resource_link_id = 'an awesome course id'
      context_title = 'A course (AKA context) title'
      course = stub_course(
        resource_link_id: resource_link_id,
        context_title: context_title
      )
      stub_user

      get :index

      expect(Course).to have_received(
        :find_or_initialize_by
      ).with(resource_link_id: resource_link_id)
      expect(course).to have_received(:title=).with(context_title)
      expect(course).to have_received(:save!)
    end

    context 'viewed by learners' do
      it 'shows only approved videos when course requires approval' do
        user = stub_user
        course = stub_course
        course.review_required = true
        videos_double = double('videos finder').as_null_object
        allow(course).to receive(:videos).and_return(videos_double)

        get :index

        expect(course.videos.approved).to have_received(:all)
      end

      it 'shows all videos when a course does not require approval' do
        user = stub_user
        course = stub_course
        course.review_required = false
        videos_double = double('videos finder').as_null_object
        allow(course).to receive(:videos).and_return(videos_double)

        get :index

        expect(course).to have_received(:videos)
        expect(course.videos).not_to have_received(:approved)
        expect(course.videos).not_to have_received(:not_approved)
      end
    end

    it 'shows all videos to instructors' do
      user = stub_user

      course = stub_course
      allow(course).to receive(:user_has_role?).and_return(true)
      course.review_required = true

      videos_double = double('videos finder').as_null_object
      allow(course).to receive(:videos).and_return(videos_double)

      get :index

      expect(course).to have_received(:videos)
      expect(course.videos).not_to have_received(:approved)
      expect(course.videos).not_to have_received(:not_approved)
      expect(course).to have_received(:user_has_role?).with(user, 'instructor')
    end
  end

  context '#show' do
    it 'finds videos for a visitor' do
      course = stub_course
      user = stub_user

      allow(Video).to receive_message_chain(
        :by_course_id, :find_by
      ).and_return([])

      get :show

      expect(Video).to have_received(:by_course_id).with(course.id)
      expect(Video.by_course_id).to have_received(:find_by).with(
        dce_lti_user_id: user.id
      )
    end
  end

  context '#update' do
    context 'learners' do
      it 'does not update when a user does not own the video' do
        stub_user
        video = build(:video, id: 100)
        allow(video).to receive(:save!)

        put :update, id: video.id

        expect(video).not_to have_received(:save!)
        expect(controller).to redirect_to(root_path)
      end
    end

    context 'instructors' do
      it 'can update a video' do
        user = stub_user
        course = stub_course
        course.review_required = true
        allow(course).to receive(:user_has_role?).and_return(true)
        video = build(:video, approved: false, course: course, id: 1000)
        allow(video).to receive(:approved=)
        allow(course).to receive_message_chain(:videos, :find).and_return(video)

        put :update, id: video.id, video: { approved: true }

        expect(video).to have_received(:approved=).with(true)
        expect(course.videos).to have_received(:find).with(video.id.to_s)
        expect(flash).to include(['notice', t('videos.updated')])
        expect(response).to redirect_to(root_path)
        expect(course).to have_received(:user_has_role?).with(user, 'instructor')
      end
    end

    it 'redirects to the homepage if updating fails' do
      user = stub_user
      course = stub_course
      allow(course).to receive(:user_has_role?).and_return(true)

      video = build(:video, id: 100)
      allow(video).to receive(:save!).and_raise

      put :update, id: video.id, approved: true

      expect(flash).to include(['error', t('videos.save_failed')])
      expect(response).to redirect_to(root_path)
    end
  end

  context '#create' do
    it 'uses CourseUserVideoCreator to create a new video for a user' do
      course_id = 1000
      youtube_id = 'abcdefg'
      description = 'a description'
      source = 'no_video'
      user = stub_user
      course = build(:course, id: course_id)
      allow(course).to receive(:new_record?).and_return(false)

      allow(Course).to receive(:find_or_initialize_by).and_return(course)
      allow(CourseUserVideoCreator).to receive(:create)

      post :create, { video: { youtube_id: youtube_id, description: description, source: source } }

      expect(CourseUserVideoCreator).to have_received(:create).with(
        youtube_id: youtube_id,
        dce_lti_user_id: user.id,
        course_id: course_id,
        description: description,
        source: source
      )
      expect(response).to redirect_to(my_video_path)
    end

    it 'returns a logical failure code when creating a video fails' do
      stub_user
      allow(CourseUserVideoCreator).to receive(:create).and_raise

      post :create, { video: { source: 'existing', youtube_id: '' } }

      expect(response).to have_rendered(:new)
    end
  end

  context '#destroy' do
    context 'accessed by instructors' do
      it 'can destroy a video' do
        user = stub_user
        course = stub_course
        allow(course).to receive(:user_has_role?).and_return(true)

        video = build(:video, id: 1000)
        allow(course).to receive_message_chain(:videos, :find).and_return(video)
        allow(video).to receive(:destroy)

        delete :destroy, id: video.id

        expect(response).to redirect_to(root_path)
        expect{Video.find(video.id)}.to raise_error
        expect(flash).to include(['notice', t('videos.destroyed')])
        expect(course).to have_received(:user_has_role?).with(user, 'instructor')
      end
    end

    context 'accessed by video owner' do
      it 'can destroy a video' do
        user = stub_user
        course = stub_course
        video = build(:video, dce_lti_user: user, id: 1000)
        allow(course).to receive_message_chain(:videos, :find).and_return(video)
        allow(video).to receive(:destroy)

        delete :destroy, id: video.id

        expect(response).to redirect_to(root_path)
        expect{Video.find(video.id)}.to raise_error
        expect(flash).to include(['notice', t('videos.destroyed')])
      end
    end

    context 'accessed by non-instructors and non-video owner' do
      it 'does not attempt to destroy a video' do
        stub_user
        course = stub_course
        video = build(:video, id: 1000)
        allow(video).to receive(:destroy)
        allow(course).to receive_message_chain(:videos, :find).and_return(video)

        delete :destroy, id: video.id

        expect(response).to redirect_to(root_path)
        expect(video).not_to have_received(:destroy)
      end
    end
  end

end
