class AddStripeUserIdToTeacher < ActiveRecord::Migration
  def change
    add_column :teachers, :stripe_user_id, :string
  end
end
