class Course < ActiveRecord::Base
  has_many :videos,
    dependent: :destroy
  has_many :course_roles,
    dependent: :destroy
  has_many :dce_lti_users,
    through: :course_roles, class: DceLti::User

  validates :resource_link_id,
    length: { maximum: 255 },
    presence: true

  validates :title,
    length: { maximum: 255 }

  validates :upload_description, :welcome_message,
    length: { maximum: 2.kilobytes }

  def user_has_role?(user, role)
    self.course_roles.where(dce_lti_user_id: user.id, role: role.downcase).present?
  end

  def grant_roles_for_user(user, roles)
    ActiveRecord::Base.transaction do
      self.course_roles.where(dce_lti_user_id: user.id).destroy_all
      roles.each do |role|
        CourseRole.create!(
          dce_lti_user_id: user.id,
          course_id: self.id,
          role: role
        )
      end
    end
  end
end
