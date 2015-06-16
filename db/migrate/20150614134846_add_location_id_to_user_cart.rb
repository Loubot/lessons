class AddLocationIdToUserCart < ActiveRecord::Migration
  def change
    add_column :user_carts, :location_id, :integer
  end
  add_index :user_carts, :student_email
  add_index :user_carts, :student_id
end