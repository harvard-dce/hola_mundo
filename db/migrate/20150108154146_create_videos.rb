class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.belongs_to :dce_lti_user, index: true, nil: false
      t.string :youtube_id, nil: false
      t.string :resource_link_id, nil: false
    end

    add_index :videos, :resource_link_id
  end
end
