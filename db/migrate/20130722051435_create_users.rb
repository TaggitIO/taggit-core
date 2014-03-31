class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :github_id,      :integer, null: false
      t.column :github_token,   :string
      t.column :login,          :string
      t.column :name,           :string
      t.column :email,          :string
      t.column :gravatar_id,    :string
      t.column :syncing,        :boolean, default: false
      t.column :last_synced_at, :datetime
      t.column :email_opt_out,  :boolean, default: false

      t.timestamps
    end
  end
end
