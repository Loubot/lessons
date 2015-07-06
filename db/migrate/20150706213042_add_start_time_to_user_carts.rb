class AddStartTimeToUserCarts < ActiveRecord::Migration
  def change
    add_column :user_carts, :start_time, :datetime
    add_column :user_carts, :price_id, :integer, default: nil
    add_column :user_carts, :date, :date
  end
end
