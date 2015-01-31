class AddUidProviderToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :uid, :string
    add_column :teachers, :provider, :string
  end
end
