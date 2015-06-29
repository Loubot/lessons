class AddLocationIdToGrinds < ActiveRecord::Migration
  def change
    add_column :grinds, :location_id, :integer
  end
end
