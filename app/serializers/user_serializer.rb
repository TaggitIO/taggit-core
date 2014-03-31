class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :name, :email, :gravatar_id, :email_opt_out
end
