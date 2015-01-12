class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :title
      t.string :resource_link_id, nil: false
      t.boolean :review_required, default: true
    end

    add_index :courses, :resource_link_id, unique: true
  end
end
