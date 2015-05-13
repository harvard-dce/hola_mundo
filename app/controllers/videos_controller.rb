class VideosController < ApplicationController
  before_filter :initialize_course, :initialize_course_roles
  before_filter :find_my_video, only: [:index, :new]
  before_filter :only_instructors, only: [:update]

  def new
    @video = Video.new
    if @my_video
      @video.description = @my_video.description
      @video.source = @my_video.source
      @video.youtube_id = @my_video.youtube_id
    end
  end

  def show
    @my_video = video_for_current_user || Video.new
  end

  def index
    @filter_set = create_filter_set

    @videos = @filter_set.apply_to(course.videos)
    if ! all_videos_visible?
      @videos = @videos.approved.all
    end
    if @videos.empty?
      flash[:notice] = t("videos.#{course.review_required? ? 'review_required_but_' : 'review_not_required_but_' }none_yet")
    end
  end

  def create
    CourseUserVideoCreator.create(
      youtube_id: video_params[:youtube_id],
      description: video_params[:description],
      source: video_params[:source],
      dce_lti_user_id: current_user.id,
      course_id: course.id
    )
    flash[:notice] = t('videos.updated')
    redirect_to my_video_path
  rescue => e
    logger.warn "Creating a video failed: #{e.inspect}"
    @video = Video.new(video_params)
    render :new
  end

  def destroy
    video = course.videos.find(params[:id])
    if video_can_be_destroyed_by_user?(video)
      video.destroy
      flash[:notice] = t('videos.destroyed')
    end
  rescue => e
    logger.warn "Could not destroy video: #{e.inspect}"
  ensure
    redirect_to root_path
  end

  def update
    begin
      video = course.videos.find(params[:id])
      video.approved = video_params[:approved]
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

  def video_can_be_destroyed_by_user?(video)
    course.user_has_role?(current_user,'instructor') ||
      video.dce_lti_user == current_user
  end

  def all_videos_visible?
    ! course.review_required? || course.user_has_role?(current_user,'instructor')
  end

  def video_for_current_user
    Video.by_course_id(course.id).find_by(
      dce_lti_user_id: current_user.id
    )
  end

  def find_my_video
    @my_video = video_for_current_user
  end

  def video_params
    params.require(:video).permit(:description, :youtube_id, :source, :existing_youtube_video, :approved)
  end

  def create_filter_set
    FilterSet.new(params.fetch(:filter_set, {}))
  end
end
