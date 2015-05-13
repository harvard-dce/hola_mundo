class AddDescriptionToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :description, :string, limit: 2048
  end
end
