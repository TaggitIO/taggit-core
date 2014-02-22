class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :name, :email, :gravatar_id
end
