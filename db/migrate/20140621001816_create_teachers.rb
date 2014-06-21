class CreateTeachers < ActiveRecord::Migration
  def change
    create_table :teachers do |t|
      t.string :first_name
      t.string :last_name
      t.text :address
      t.text :overview

      t.timestamps
    end
  end
end
