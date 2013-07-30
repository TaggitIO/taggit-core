class CreateOwners < ActiveRecord::Migration
  def change
    create_table :owners do |t|
      t.column :github_id,    :integer
      t.column :login,        :string
      t.column :name,         :string

      t.timestamps
    end
  end
end
