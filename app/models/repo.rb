class Repo < ActiveRecord::Base
  belongs_to :owner
  has_many :subscriptions
  has_many :releases

  # Public: Attempts to create a web hook for a repo. Raises an exception if
  # the hook has already been created on the Repo.
  #
  # user - The User object to authenticate with GitHub.
  #
  # Examples
  #   repo.create_hook!(user)
  #   # => #<Sawyer::Resource:...>
  #
  # Returns the Sawyer::Resource object for the hook creation response or
  # raises an error.
  def create_hook!(user)
    client = Octokit::Client.new(access_token: user.github_token)

    client.create_hook(
      full_name,
      'web',
      {
        url:          Constants::HOOK_URL,
        content_type: 'json'
      },
      {
        events: ['release'],
        active: true
      }
    )
  end

end
