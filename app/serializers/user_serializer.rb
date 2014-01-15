class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :name, :email, :gravatar_id
  has_many :repos
end
