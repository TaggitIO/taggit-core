class User < ActiveRecord::Base

  # Public: Find or create a User based on their GitHub profile.
  #
  # auth_hash - A Hash of GitHub information returned from an OmniAuth request.
  #
  # Examples
  #   User.from_github(auth_hash)
  #   # => #<User id: 1, github_uid:...>
  #
  # Returns the User. 
  def self.from_github(auth_hash)
    github_uid   = auth_hash['uid']
    github_token = auth_hash['credentials']['token']


    user = where(github_uid: github_uid).first_or_create do |user|
      user.github_uid      = github_uid
      user.github_token    = github_token
      user.github_nickname = auth_hash['info']['nickname']
      user.name            = auth_hash['info']['name']
      user.email           = auth_hash['info']['email']
      user.gravatar_id     = auth_hash['extra']['raw_info']['gravatar_id']
    end

    if user.github_token != github_token
      user.update_column(:github_token, github_token)
    end

    user
  end

end
