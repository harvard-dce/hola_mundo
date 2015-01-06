class UserVideoCreator
  def self.create(youtube_id:, dce_lti_user_id:, resource_link_id:)
    Video.by_resource_link_id(resource_link_id).find_or_initialize_by(
      dce_lti_user_id: dce_lti_user_id
    ).tap do |video|
      video.youtube_id = youtube_id
    end.save!
  end
end
