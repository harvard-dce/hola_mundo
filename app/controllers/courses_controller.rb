class CoursesController < ApplicationController
  before_filter :only_instructors, :initialize_course

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
