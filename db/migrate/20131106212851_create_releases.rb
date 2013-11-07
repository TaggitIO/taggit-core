class CreateReleases < ActiveRecord::Migration
  def change
    create_table :releases do |t|
      t.column :repo_id,      :integer
      t.column :github_id,    :integer
      t.column :html_url,     :string
      t.column :tag_name,     :string
      t.column :body,         :text
      t.column :prerelease,   :boolean
      t.column :published_at, :datetime

      t.timestamps
    end
  end
end
