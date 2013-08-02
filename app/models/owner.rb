class Owner < ActiveRecord::Base
  has_many :repos
  has_and_belongs_to_many :users

  # Public: Attempts to find an Owner with the same login and creates a new
  # Owner if it isn't found.
  #
  # owner - Either an existing User object or a Hashie::Mash object that
  # represents a GitHub organization.
  # user - The User object to associate the Owner with.
  #
  # Examples
  #   find_or_create_owner(some_dude)
  #   # => #<Owner id: 1, github_id:...>
  #
  # Returns the Owner object.
  def self.find_or_create(owner, user)
    new_owner = Owner.find_or_create_by(login: owner.login) do |o|
      o.github_id    = owner.try(:github_id) || owner.try(:id)
      o.login        = owner.login
      o.name         = owner.try(:name) || owner.login
    end

    # Add the Owner object to a User if they have not already been associated.
    unless user.owners.map(&:id).include?(new_owner.id)
      user.owners << new_owner
    end

    new_owner
  end
  
end
