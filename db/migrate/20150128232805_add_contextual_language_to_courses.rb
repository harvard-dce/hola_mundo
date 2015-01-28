class AddContextualLanguageToCourses < ActiveRecord::Migration
  def change
    add_column(:courses, :upload_description, :string, limit: 2.kilobytes)
    add_column(:courses, :welcome_message, :string, limit: 2.kilobytes)
  end
end
