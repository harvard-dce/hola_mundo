class AddTimestamps < ActiveRecord::Migration
  def change
    add_timestamps(:courses)
    add_timestamps(:videos)
  end
end
