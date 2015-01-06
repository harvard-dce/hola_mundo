class Video < ActiveRecord::Base
  belongs_to :dce_lti_user

  validates :dce_lti_user_id,
    presence: true

  validates :youtube_id,
    presence: true,
    length: { maximum: 20 }

  validates :resource_link_id,
    presence: true,
    length: { maximum: 255 }

  def self.by_resource_link_id(resource_link_id)
    where(resource_link_id: resource_link_id)
  end
end
