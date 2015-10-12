class AddWeeksToGrinds < ActiveRecord::Migration
  def change
    add_column :grinds, :weeks, :integer, default: 1
    add_column :grinds, :level, :string
    add_column :grinds, :duration, :integer, default: 0
    add_column :user_carts, :grind_id, :integer
    add_column :user_carts, :places, :integer, default: 0
    rename_column :grinds, :start_time, :start_date
  end
end
