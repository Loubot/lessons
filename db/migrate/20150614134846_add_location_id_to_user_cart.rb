class AddLocationIdToUserCart < ActiveRecord::Migration
  def change
    add_column :user_carts, :location_id, :integer
  end
end
