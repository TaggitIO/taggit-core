class UserSerializer < ActiveModel::Serializer
  attributes :id, :login, :name, :email, :gravatar_url

  def gravatar_url
    "http://www.gravatar.com/avatar/#{object.gravatar_id}"
  end
end
