class CoursesController < ApplicationController
  before_filter :initialize_course, :initialize_course_roles, :only_instructors

  def edit
  end

  def update
    begin
      course.review_required = course_params[:review_required]
      course.welcome_message = course_params[:welcome_message]
      course.upload_description = course_params[:upload_description]
      course.save!

      flash[:notice] = t('courses.updated')
      redirect_to edit_course_path
    rescue => e
      flash[:error] = t('courses.save_failed')
      render :edit
    end
  end

  private

  def course_params
    params.fetch(:course, {})
  end
end
