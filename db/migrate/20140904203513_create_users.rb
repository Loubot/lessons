class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.text :first_name
      t.text :last_name

      t.timestamps
    end
  end
end

# rake db:migrate:down VERSION=20140904203513 --trace