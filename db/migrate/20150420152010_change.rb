class Change < ActiveRecord::Migration
  def self.up
    change_column :user_carts, :home_booking, :string, default: ''
    rename_column :user_carts, :home_booking, :booking_type
    add_column    :user_carts, :package_id,   :integer, default: 0
  end

  def self.down
    remove_column :user_carts, :booking_type
    add_column :user_carts, :home_booking, :boolean, default: false
    remove_column :user_carts, :package_id
  end
end