class Video < ActiveRecord::Base
  before_create :ensure_review_is_required

  belongs_to :dce_lti_user, class: DceLti::User
  belongs_to :course

  validates :dce_lti_user_id,
    presence: true,
    uniqueness: { scope: :course_id }

  validates :youtube_id,
    presence: true,
    length: { maximum: 20 }

  validates :course_id,
    presence: true

  delegate :review_required?, to: :course

  def self.approved
    where(approved: true)
  end

  def self.by_course_id(course_id)
    where(course_id: course_id)
  end

  private

  def ensure_review_is_required
    if self.course.review_required
      self.approved = false
    else
      self.approved = true
    end
    true
  end
end
