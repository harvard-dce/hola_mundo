class ChangeDefaultVideoSource < ActiveRecord::Migration
  def change
    change_column_default(:videos, :source, 'existing')
  end
end
