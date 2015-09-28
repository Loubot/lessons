class AddWeeksToGrinds < ActiveRecord::Migration
  def change
    add_column :grinds, :weeks, :integer, default: 1
  end
end
