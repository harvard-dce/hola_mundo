class VideosController < ApplicationController
  def index
    @my_video = find_my_video
  end

  def create
    begin
      UserVideoCreator.create(
        youtube_id: video_params[:youtube_id],
        dce_lti_user_id: current_user.id,
        resource_link_id: session[:resource_link_id]
      )
      head :created
    rescue => e
      logger.warn "Creating a video failed: #{e.inspect}"
      head :unprocessable_entity
    end
  end

  private

  def find_my_video
    Video.by_resource_link_id(session[:resource_link_id]).find_by(
      dce_lti_user_id: current_user.id
    )
  end

  def video_params
    params.fetch(:video, {})
  end
end
