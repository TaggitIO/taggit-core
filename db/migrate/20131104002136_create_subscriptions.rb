class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.column :user_id, :integer
      t.column :repo_id, :integer
      t.column :email,   :string

      t.timestamps
    end
  end
end
