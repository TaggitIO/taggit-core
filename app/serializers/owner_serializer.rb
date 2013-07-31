class OwnerSerializer < ActiveModel::Serializer
  attributes :id, :github_id, :login, :name
end
