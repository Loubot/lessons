class CreateUserCarts < ActiveRecord::Migration
  def change
    create_table :user_carts do |t|
      t.integer :teacher_id
      t.integer :student_id
      t.text :params
      t.text :tracking_id
      t.timestamps
    end
  end
end
