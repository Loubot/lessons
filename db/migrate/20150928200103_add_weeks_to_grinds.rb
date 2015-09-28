class AddWeeksToGrinds < ActiveRecord::Migration
  def change
    add_column :grinds, :weeks, :integer, default: 1
    add_column :grinds, :level, :string
  end
end
