class FilterSet
  include ActiveModel::Model
  attr_accessor :approval_state, :name, :sort_by

  def self.approval_options
    [
      [I18n.t('videos.options.approval_state.all_videos'), ''],
      [I18n.t('videos.options.approval_state.approved'), 'approved'],
      [I18n.t('videos.options.approval_state.not_approved'), 'not_approved']
    ]
  end

  def self.sort_by_values
    [
      [I18n.t('videos.options.sort_by.updated_at_desc'), 'updated_at_desc'],
      [I18n.t('videos.options.sort_by.updated_at_asc'), 'updated_at_asc'],
      [I18n.t('videos.options.sort_by.name_asc'), 'name_asc'],
      [I18n.t('videos.options.sort_by.name_desc'), 'name_desc']
    ]
  end

  def apply_to(videos)
    filtered_videos = videos.joins(:dce_lti_user)
    # These are scopes on the videos model, only send the method if it's one of
    # these two to remove code injection vector
    if self.approval_state.in?(['approved', 'not_approved'])
      filtered_videos = videos.send(self.approval_state)
    end
    if self.name.present?
      filtered_videos = filtered_videos.where(
        ['dce_lti_users.lis_person_name_full like (?)', "#{self.name}%"]
      )
    end
    filtered_videos.order(sorting_method_sql_fragment)
  end

  private

  def sorting_method_sql_fragment
    sort_map = {
      'updated_at_desc' => 'videos.updated_at desc',
      'updated_at_asc' => 'videos.updated_at asc',
      'name_asc' => 'dce_lti_users.lis_person_name_full asc',
      'name_desc' => 'dce_lti_users.lis_person_name_full desc'
    }
    sort_map.fetch(self.sort_by, sort_map['updated_at_desc'])
  end
end
