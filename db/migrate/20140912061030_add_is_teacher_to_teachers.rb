class AddIsTeacherToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :is_teacher, :boolean
  end
end
