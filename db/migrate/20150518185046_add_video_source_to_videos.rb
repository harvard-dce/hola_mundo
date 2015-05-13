class AddVideoSourceToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :source, :string, default: 'camera'
  end
end
