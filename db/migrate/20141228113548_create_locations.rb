class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :teacher_id
      t.float :latitude
      t.float :longitude
      t.string :name
      t.text :address

      t.timestamps
    end
    add_index :locations, :teacher_id
    add_column :locations, :price, :decimal, :precision => 8, :scale => 2
    remove_column :teachers, :lat, :float
    remove_column :teachers, :lon, :float
    remove_column :teachers, :address, :text
  end
end
