class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_via_lti
  helper_method :current_user, :course

  private

  def initialize_course
    @course = Course.find_or_initialize_by(
      resource_link_id: session[:resource_link_id]
    )
    if @course.new_record?
      @course.title = session[:context_title]
      @course.save!
    end
  end

  def initialize_course_roles
    course.grant_roles_for_user(current_user, get_roles_from_session)
  end

  def get_roles_from_session
    session[:roles] || []
  end

  def course
    @course
  end

  def only_instructors
    if ! course.user_has_role?(current_user, 'instructor')
      redirect_to root_path
    end
  end
end
