class VideosController < ApplicationController
  before_filter :initialize_course
  before_filter :only_instructors, only: [:update]
  before_filter :find_my_video, only: [:show, :index, :new]

  def show
  end

  def index
    if all_videos_visible?
      @videos = course.videos.all
    else
      @videos = course.videos.approved.all
    end
    if @videos.empty?
      flash[:notice] = t("videos.#{course.review_required? ? 'review_required_but_' : 'review_not_required_but_' }none_yet")
    end
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

  def all_videos_visible?
    ! course.review_required? || current_user.has_role?('instructor')
  end

  def find_my_video
    @my_video = Video.by_course_id(course.id).find_by(
      dce_lti_user_id: current_user.id
    )
  end

  def video_params
    params.fetch(:video, {})
  end
end
