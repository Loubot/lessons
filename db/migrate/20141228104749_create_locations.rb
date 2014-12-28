class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.integer :teacher_id
      t.float :latitude
      t.float :longitude
      t.string :name

      t.timestamps

      add_index :locations, :teacher_id
    end
    remove_column :teachers, :lat
    remove_column :teachers, :lon
  end
end
