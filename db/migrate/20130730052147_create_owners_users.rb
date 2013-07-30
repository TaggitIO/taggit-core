class CreateOwnersUsers < ActiveRecord::Migration
  def change
    create_table :owners_users do |t|
      t.column :user_id,  :integer
      t.column :owner_id, :integer
    end
  end
end
