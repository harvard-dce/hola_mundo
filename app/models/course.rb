class Course < ActiveRecord::Base
  has_many :videos, dependent: :destroy
  validates :resource_link_id,
    length: { maximum: 255 },
    presence: true

  validates :title,
    length: { maximum: 255 }

  def toggle_review_required
    if review_required
      self.review_required = false
    else
      self.review_required = true
    end
  end
end
