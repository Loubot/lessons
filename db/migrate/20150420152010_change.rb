class Change < ActiveRecord::Migration
  def self.up
  	change_column :user_carts,  :home_booking,  :string, default: ''
  	rename_column :user_carts,  :home_booking,  :booking_type
  	add_column    :user_carts,  :package_id,	  :integer, default: 0
    add_column    :teachers,    :paid_up,       :boolean, default: false
    add_column    :teachers,    :paid_up_date,  :date
  end

  def self.down
  	remove_column :user_carts,   :booking_type
  	add_column :user_carts,      :home_booking, :boolean, default: false
  	remove_column :user_carts,   :package_id
    remove_column :teachers,     :paid_up
    remove_column :teachers,     :paid_up_date 
  end
end
