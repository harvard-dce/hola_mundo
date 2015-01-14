class VideosController < ApplicationController
  before_filter :initialize_course
  before_filter :only_instructors, only: [:update]

  def show
    @my_video = find_my_video
  end

  def index
    @videos = course.videos
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

  def destroy
    begin
      video = course.videos.find(params[:id])
      if current_user.has_role?('instructor') ||
        video.dce_lti_user == current_user
        video.destroy
        flash[:notice] = t('videos.destroyed')
      end
    rescue => e
      logger.warn "Could not destroy video: #{e.inspect}"
    ensure
      redirect_to root_path
    end
  end

  def update
    begin
      video = course.videos.find(params[:id])
      video.approved = params[:approved]
      video.save!
      flash[:notice] = t('videos.updated')
    rescue => e
      flash[:error] = t('videos.save_failed')
      logger.warn "Could not update video: #{e.inspect}"
    ensure
      redirect_to root_path
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
