class CoursesController < ApplicationController
  before_filter :only_instructors, :initialize_course

  def review_toggle
    course.toggle_review_required
    course.save!
    flash[:notice] = t('courses.toggled')
    redirect_to root_path
  end
end
