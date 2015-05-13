class Video < ActiveRecord::Base
  SOURCES = {
    I18n.t('videos.sources.camera') => 'camera',
    I18n.t('videos.sources.existing') => 'existing',
    I18n.t('videos.sources.no_video') => 'no_video',
  }

  attr_writer :existing_youtube_video

  before_create :ensure_review_is_required

  belongs_to :dce_lti_user, class: DceLti::User
  belongs_to :course

  validates :dce_lti_user_id,
    presence: true,
    uniqueness: { scope: :course_id }

  validates :youtube_id,
    length: { maximum: 20 }

  validates :course_id,
    presence: true

  validates :description,
    length: { maximum: 2.kilobytes }

  delegate :review_required?, to: :course

  def existing_youtube_video
    if youtube_id.present? && source == 'existing'
      %Q|https://www.youtube.com/watch?v=#{youtube_id}|
    end
  end

  def self.approved
    where(approved: true)
  end

  def self.not_approved
    where(approved: false)
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
