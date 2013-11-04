class SubscriptionSerializer < ActiveModel::Serializer
  attributes :repo, :email

  def repo
    object.repo.full_name
  end
end
