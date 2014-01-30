class User < ActiveRecord::Base

  has_and_belongs_to_many :owners
  has_many :repos, through: :owners

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
    github_id   = auth_hash['uid']
    github_token = auth_hash['credentials']['token']


    user = where(github_id: github_id).first_or_create do |user|
      user.github_id      = github_id
      user.github_token    = github_token
      user.login           = auth_hash['info']['nickname']
      user.name            = auth_hash['info']['name']
      user.email           = auth_hash['info']['email']
      user.gravatar_id     = auth_hash['extra']['raw_info']['gravatar_id']
    end

    # Create an Owner with the same attributes as the User.
    Owner.find_or_create(user, user)

    if user.github_token != github_token
      user.update_column(:github_token, github_token)
    end

    user
  end

  # Public: Syncs a User's organizations and repositories from GitHub and
  # creates them as necessary.
  #
  # Examples
  #   user.sync_with_github!
  #   # => true
  #
  # Returns true if user is synced successfully.
  #
  # TODO: Write test cases.
  def sync_with_github!
    client = Octokit::Client.new(access_token: github_token)
    orgs = client.orgs

    @repos = select_repos(client.repos)

    orgs.each { |org| @repos << select_repos(client.repos(org.login)) }
    @repos.flatten!

    purge_repos!
    create_repos!

    self.last_synced_at = Time.now
    self.syncing        = false
    self.save!

    true
  end

  private

  # Private: From a list of repos, get the repos where the User is an admin and
  # the repo is public.
  #
  # repos - An array of repos from GitHub.
  #
  # Examples
  #   select_repos(some_repos)
  #   # => [{"id"=>10495792, "name"=>"backbone.model.toggle","full_name"=>...]
  #
  # Returns an array of repo data.
  def select_repos(repos)
    repos.select do |repo|
      !repo.private? && repo.permissions.admin?
    end
  end

  # Private: Create Repo objects from a User's GitHub.
  def create_repos!
    @repos.each do |repo|
      next if Repo.find_by_github_id(repo.id)

      owner = Owner.find_or_create(repo.owner, self)

      Repo.create!(
        owner_id:    owner.id,
        github_id:   repo.id,
        name:        repo.name,
        full_name:   repo.full_name,
        description: repo.description
      )
    end
  end

  # Private: Destroy all Repo objects that no longer exist on GitHub.
  def purge_repos!
    repo_ids = @repos.collect { |repo| repo.id }

    repos.each do |repo|
      repo.destroy! unless repo_ids.include? repo.github_id
    end
  end

end
