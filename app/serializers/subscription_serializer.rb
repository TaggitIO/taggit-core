class SubscriptionSerializer < ActiveModel::Serializer
  attributes :user_id, :repo, :email

  def repo
    object.repo.full_name
  end
end
