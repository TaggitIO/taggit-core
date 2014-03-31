class ReleaseSerializer < ActiveModel::Serializer
  embed :ids, include: true

  attributes :id, :html_url, :tag_name, :published_at

  has_one :repo
end
