class VideosController < ApplicationController
  before_filter :initialize_course

  def index
    @my_video = find_my_video
  end

  def create
    begin
      CourseUserVideoCreator.create(
        youtube_id: video_params[:youtube_id],
        dce_lti_user_id: current_user.id,
        course_id: course.id
      )
      head :created
    rescue => e
      logger.warn "Creating a video failed: #{e.inspect}"
      head :unprocessable_entity
    end
  end

  private

  def find_my_video
    Video.by_course_id(course.id).find_by(
      dce_lti_user_id: current_user.id
    )
  end

  def video_params
    params.fetch(:video, {})
  end
end
