class RepoSerializer < ActiveModel::Serializer
  attributes :id, :github_id, :name, :url, :active, :description
end
