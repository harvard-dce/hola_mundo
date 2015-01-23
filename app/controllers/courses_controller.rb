class CoursesController < ApplicationController
  before_filter :initialize_course, :initialize_course_roles, :only_instructors

  def edit
  end

  def update
    course.review_required = course_params[:review_required]
    course.save!

    flash[:notice] = t('courses.updated')

    redirect_to edit_course_path
  end

  private

  def course_params
    params.fetch(:course, {})
  end
end
