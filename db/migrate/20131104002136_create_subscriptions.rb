class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.column :email,   :string
      t.column :repo_id, :integer
      
      t.timestamps
    end
  end
end
