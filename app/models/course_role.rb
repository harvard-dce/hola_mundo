class CourseRole < ActiveRecord::Base
  belongs_to :dce_lti_user,
    class_name: DceLti::User
  belongs_to :course

  validates :dce_lti_user_id,
    presence: true
  validates :course_id,
    presence: true
  validates :role,
    presence: true
end
