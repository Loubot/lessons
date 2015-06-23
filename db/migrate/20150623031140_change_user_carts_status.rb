class ChangeUserCartsStatus < ActiveRecord::Migration
  def change
    rename_column :user_carts, :string, :status
  end
end
