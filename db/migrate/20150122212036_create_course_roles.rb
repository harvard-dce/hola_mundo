class CreateCourseRoles < ActiveRecord::Migration
  def change
    create_table :course_roles do |t|
      t.belongs_to :dce_lti_user, index: true
      t.belongs_to :course, index: true
      t.string :role, null: false

      t.timestamps
    end
    add_index :course_roles, :role
  end
end
