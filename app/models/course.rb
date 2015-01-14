class Course < ActiveRecord::Base
  has_many :videos, dependent: :destroy
  validates :resource_link_id,
    length: { maximum: 255 },
    presence: true

  validates :title,
    length: { maximum: 255 }
end
