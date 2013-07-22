class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.column :github_uid,      :integer, null: false
      t.column :github_token,    :string
      t.column :github_nickname, :string
      t.column :name,            :string
      t.column :email,           :string
      t.column :gravatar_id,     :string
      t.column :sign_in_count,   :integer, default: 0
      
      t.timestamps
    end
  end
end
