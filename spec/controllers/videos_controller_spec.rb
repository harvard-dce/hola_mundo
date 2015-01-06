describe VideosController do
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
    it 'visits are successful' do
      stub_user

      get :index

      expect(response).to be_successful
    end

    it 'finds videos for a visitor' do
      resource_link_id = 'foobar'
      session[:resource_link_id] = resource_link_id
      user = stub_user

      resource_link_scoped_videos_double = double('Found vids by resource_link_id')
      allow(resource_link_scoped_videos_double).to receive(:find_by)
      allow(Video).to receive(:by_resource_link_id).and_return(
        resource_link_scoped_videos_double
      )

      get :index

      expect(Video).to have_received(:by_resource_link_id).with(
        resource_link_id
      )
      expect(resource_link_scoped_videos_double).to have_received(:find_by).
        with(dce_lti_user_id: user.id)
    end
  end

  context '#create' do
    it 'uses UserVideoCreator to create a new video for a user' do
      resource_link_id = 'foobar'
      session[:resource_link_id] = resource_link_id
      youtube_id = 'abcdefg'
      user = stub_user
      allow(UserVideoCreator).to receive(:create)

      post :create, { video: { youtube_id: youtube_id } }

      expect(UserVideoCreator).to have_received(:create).with(
        youtube_id: youtube_id,
        dce_lti_user_id: user.id,
        resource_link_id: resource_link_id
      )
      expect(response).to be_successful
    end

    it 'returns a logical failure code when creating a video fails' do
      stub_user
      allow(UserVideoCreator).to receive(:create).and_raise

      post :create, { video: {  } }

      expect(response.status).to eq 422
    end
  end

  def stub_user
    DceLti::User.new.tap do |user|
      user.id = 1000
      allow(DceLti::User).to receive(:find_by).and_return(user)
    end
  end
end
