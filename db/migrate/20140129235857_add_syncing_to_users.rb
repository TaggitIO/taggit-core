class AddSyncingToUsers < ActiveRecord::Migration
  def up
    add_column :users, :syncing, :boolean, default: false
    add_column :users, :last_synced_at, :datetime
  end

  def down
    remove_column :users, :syncing
    remove_column :users, :last_synced_at
  end
end
