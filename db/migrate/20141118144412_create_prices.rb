class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :subject_id
      t.integer :teacher_id
      t.decimal :home_price, :precision => 8, :scale => 2
      t.decimal :travel_price, :precision => 8, :scale => 2

      t.timestamps
    end

    remove_column :teachers, :rate
    add_index :prices, :subject_id
    add_index :prices, :teacher_id
  end
end
