class CreateExperiences < ActiveRecord::Migration
  def change
    create_table :experiences do |t|
      t.string :title
      t.text :description
      t.integer :teacher_id
      t.datetime :start
      t.datetime :end
      t.binary :present

      t.timestamps
    end
  end
end
