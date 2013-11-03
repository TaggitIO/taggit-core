class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.column :owner_id,    :integer
      t.column :github_id,   :integer
      t.column :name,        :string
      t.column :full_name,   :string
      t.column :url,         :string
      t.column :active,      :boolean, default: false
      t.column :description, :string
      t.column :private,     :boolean, default: false

      t.timestamps
    end
  end
end
