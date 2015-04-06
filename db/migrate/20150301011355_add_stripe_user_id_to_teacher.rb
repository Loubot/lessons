class AddStripeUserIdToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :stripe_user_id, :string
    add_column :user_carts, :multiple, :boolean, default: false
    add_column :user_carts, :weeks, :integer, default: 0
  end
end
