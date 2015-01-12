class AddCourseIdToVideos < ActiveRecord::Migration
  def change
    remove_column :videos, :resource_link_id

    add_column :videos, :course_id, :integer
    add_index :videos, [:course_id, :dce_lti_user_id], unique: true
  end
end
