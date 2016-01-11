class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :teacher
      t.integer :student
      t.string :student_email
      t.string :student_email
      t.text :message

      t.timestamps null: false
    end
  end
end
