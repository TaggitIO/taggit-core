class RepoSerializer < ActiveModel::Serializer
  attributes :id, :github_id, :name, :full_name, :active, :description
end
