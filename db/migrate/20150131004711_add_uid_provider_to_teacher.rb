class AddUidProviderToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :uid, :string, default: ""
    add_column :teachers, :provider, :string, default: ""
  end
end
