class ChangeDefaultReviewRequired < ActiveRecord::Migration
  def change
    change_column_default(:courses, :review_required, false)
  end
end
