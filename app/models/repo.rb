class Repo < ActiveRecord::Base
  belongs_to :owner
  has_many :subscriptions
  has_many :releases

  # Public: Activates a Repo.
  #
  # user - the User who is activating the repo.
  #
  # Examples
  #   repo.activate!(user)
  #   # => true
  #
  # Returns: true if the Repo was activated, false if the Repo was already
  # active, raises an error if the hook could not be created.
  def activate!(user)
    return false if self.active?

    @user = user

    create_hook!

    self.active = true
    self.save!
  end

  # Public: Deactivates a Repo.
  #
  # user - the User who is deactivating the repo.
  #
  # Examples
  #   repo.deactivate!(user)
  #   # => true
  #
  # Returns: true if the Repo was deactivated, false if the Repo was already
  # inactive, raises an error if the hook could not be removed.
  def deactivate!(user)
    return false unless self.active?

    @user = user

    remove_hook!

    self.active = false
    self.save!
  end

  # Public: Determines if Repo is inactive.
  #
  # Examples
  #   repo.inactive?
  #   # => false
  #
  # Returns: true if the Repo is inactive, false if it's active.
  def inactive?
    !self.active?
  end

  private

  # Private: Attempts to create a web hook for a repo. Raises an exception if
  # the hook has already been created on the Repo.
  #
  # Examples
  #   create_hook!
  #   # => 1111111
  #
  # Returns the hook ID or raises an error if the hook could not be created.
  def create_hook!
    hook = client.create_hook(
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

    self.github_hook_id = hook.id
  end

  # Private: Attempts to remove a web hook for a repo. Raises an exception if
  # the hook could not be deleted.
  #
  # Examples
  #   remove_hook!
  #   # => 1111111
  #
  # Returns nil if the hook was removed or raises an error if it could not be
  # removed.
  def remove_hook!
    client.remove_hook(full_name, github_hook_id)

    self.github_hook_id = nil
  end

  # Private: Builds a new Octokit::Client object.
  def client
    Octokit::Client.new(access_token: @user.github_token)
  end

end
