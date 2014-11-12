class AddReviewIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :review_id, :integer
  end
end
