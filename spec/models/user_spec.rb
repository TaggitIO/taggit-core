require 'spec_helper'

describe User do
  let(:auth_hash) {
    {
      'uid' => 12345,
      'info' => {
        'nickname' => 'foobar',
        'name' => 'Foo Bar',
        'email' => 'foo@bar.io'
      },
      'credentials' => { 'token' => 'somegibberish' },
      'extra' => { 'raw_info' => { 'gravatar_id' => 'moregibberish' } }
    }
  }

  let(:stubbed_org_response) do
    [
      Hashie::Mash.new(
        login: "someorg",
        id: 1111111,
        url: "https://api.github.com/orgs/someorg",
        repos_url: "https://api.github.com/orgs/someorg/repos",
        events_url: "https://api.github.com/orgs/someorg/events",
        members_url: "https://api.github.com/orgs/someorg/members{/member}",
        public_members_url: "https://api.github.com/orgs/someorg/public_members{/member}",
        avatar_url: "https://secure.gravatar.com/avatar/964fa6e7c2e05f0ae6f76063e184fd28?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-org-420.png"
      )
    ]
  end

  let(:stubbed_repo_response) do
    [
      Hashie::Mash.new(
        id: 11111111,
        name: "somerepo",
        full_name: "foo/somerepo",
        owner: {
          login: "foo",
          id: 1234,
          avatar_url: "https://secure.gravatar.com/avatar/a94edca826063cff49f9da47f84560ed?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
          gravatar_id: "a94edca826063cff49f9da47f84560ed",
          url: "https://api.github.com/users/foo",
          html_url: "https://github.com/foo",
          followers_url: "https://api.github.com/users/foo/followers",
          following_url: "https://api.github.com/users/foo/following{/other_user}",
          gists_url: "https://api.github.com/users/foo/gists{/gist_id}",
          starred_url: "https://api.github.com/users/foo/starred{/owner}{/repo}",
          subscriptions_url: "https://api.github.com/users/foo/subscriptions",
          organizations_url: "https://api.github.com/users/foo/orgs",
          repos_url: "https://api.github.com/users/foo/repos",
          events_url: "https://api.github.com/users/foo/events{/privacy}",
          received_events_url: "https://api.github.com/users/foo/received_events",
          type: "User"
        },
        private: false,
        html_url: "https://github.com/foo/somerepo",
        description: "WHEEE!",
        fork: false,
        url: "https://api.github.com/repos/foo/somerepo",
        forks_url: "https://api.github.com/repos/foo/somerepo/forks",
        keys_url: "https://api.github.com/repos/foo/somerepo/keys{/key_id}",
        collaborators_url: "https://api.github.com/repos/foo/somerepo/collaborators{/collaborator}",
        teams_url: "https://api.github.com/repos/foo/somerepo/teams",
        hooks_url: "https://api.github.com/repos/foo/somerepo/hooks",
        issue_events_url: "https://api.github.com/repos/foo/somerepo/issues/events{/number}",
        events_url: "https://api.github.com/repos/foo/somerepo/events",
        assignees_url: "https://api.github.com/repos/foo/somerepo/assignees{/user}",
        branches_url: "https://api.github.com/repos/foo/somerepo/branches{/branch}",
        tags_url: "https://api.github.com/repos/foo/somerepo/tags",
        blobs_url: "https://api.github.com/repos/foo/somerepo/git/blobs{/sha}",
        git_tags_url: "https://api.github.com/repos/foo/somerepo/git/tags{/sha}",
        git_refs_url: "https://api.github.com/repos/foo/somerepo/git/refs{/sha}",
        trees_url: "https://api.github.com/repos/foo/somerepo/git/trees{/sha}",
        statuses_url: "https://api.github.com/repos/foo/somerepo/statuses/{sha}",
        languages_url: "https://api.github.com/repos/foo/somerepo/languages",
        stargazers_url: "https://api.github.com/repos/foo/somerepo/stargazers",
        contributors_url: "https://api.github.com/repos/foo/somerepo/contributors",
        subscribers_url: "https://api.github.com/repos/foo/somerepo/subscribers",
        subscription_url: "https://api.github.com/repos/foo/somerepo/subscription",
        commits_url: "https://api.github.com/repos/foo/somerepo/commits{/sha}",
        git_commits_url: "https://api.github.com/repos/foo/somerepo/git/commits{/sha}",
        comments_url: "https://api.github.com/repos/foo/somerepo/comments{/number}",
        issue_comment_url: "https://api.github.com/repos/foo/somerepo/issues/comments/{number}",
        contents_url: "https://api.github.com/repos/foo/somerepo/contents/{+path}",
        compare_url: "https://api.github.com/repos/foo/somerepo/compare/{base}...{head}",
        merges_url: "https://api.github.com/repos/foo/somerepo/merges",
        archive_url: "https://api.github.com/repos/foo/somerepo/{archive_format}{/ref}",
        downloads_url: "https://api.github.com/repos/foo/somerepo/downloads",
        issues_url: "https://api.github.com/repos/foo/somerepo/issues{/number}",
        pulls_url: "https://api.github.com/repos/foo/somerepo/pulls{/number}",
        milestones_url: "https://api.github.com/repos/foo/somerepo/milestones{/number}",
        notifications_url: "https://api.github.com/repos/foo/somerepo/notifications{?since,all,participating}",
        labels_url: "https://api.github.com/repos/foo/somerepo/labels{/name}",
        created_at: "2013-06-05T05:40:31Z",
        updated_at: "2013-06-14T22:48:09Z",
        pushed_at: "2013-06-06T17:37:36Z",
        git_url: "git://github.com/foo/somerepo.git",
        ssh_url: "git@github.com:foo/somerepo.git",
        clone_url: "https://github.com/foo/somerepo.git",
        svn_url: "https://github.com/foo/somerepo",
        homepage: nil,
        size: 292,
        watchers_count: 2,
        language: "JavaScript",
        has_issues: true,
        has_downloads: true,
        has_wiki: true,
        forks_count: 0,
        mirror_url: nil,
        open_issues_count: 0,
        forks: 0,
        open_issues: 0,
        watchers: 2,
        master_branch: "master",
        default_branch: "master",
        permissions: { admin: true }
      )
    ]
  end

  let(:stubbed_org_repo_response) do
    [
      Hashie::Mash.new(
        id: 10466245,
        name: "somerepo",
        full_name: "someorg/somerepo",
        owner: {
          login: "someorg",
          id: 4605503,
          avatar_url: "https://secure.gravatar.com/avatar/d41d8cd98f00b204e9800998ecf8427e?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-org-420.png",
          gravatar_id: "d41d8cd98f00b204e9800998ecf8427e",
          url: "https://api.github.com/users/someorg",
          html_url: "https://github.com/someorg",
          followers_url: "https://api.github.com/users/someorg/followers",
          following_url: "https://api.github.com/users/someorg/following{/other_user}",
          gists_url: "https://api.github.com/users/someorg/gists{/gist_id}",
          starred_url: "https://api.github.com/users/someorg/starred{/owner}{/repo}",
          subscriptions_url: "https://api.github.com/users/someorg/subscriptions",
          organizations_url: "https://api.github.com/users/someorg/orgs",
          repos_url: "https://api.github.com/users/someorg/repos",
          events_url: "https://api.github.com/users/someorg/events{/privacy}",
          received_events_url: "https://api.github.com/users/someorg/received_events",
          type: "Organization"
        },
        private: false,
        html_url: "https://github.com/someorg/somerepo",
        description: "WHEEE!",
        fork: false,
        url: "https://api.github.com/repos/someorg/somerepo",
        forks_url: "https://api.github.com/repos/someorg/somerepo/forks",
        keys_url: "https://api.github.com/repos/someorg/somerepo/keys{/key_id}",
        collaborators_url: "https://api.github.com/repos/someorg/somerepo/collaborators{/collaborator}",
        teams_url: "https://api.github.com/repos/someorg/somerepo/teams",
        hooks_url: "https://api.github.com/repos/someorg/somerepo/hooks",
        issue_events_url: "https://api.github.com/repos/someorg/somerepo/issues/events{/number}",
        events_url: "https://api.github.com/repos/someorg/somerepo/events",
        assignees_url: "https://api.github.com/repos/someorg/somerepo/assignees{/user}",
        branches_url: "https://api.github.com/repos/someorg/somerepo/branches{/branch}",
        tags_url: "https://api.github.com/repos/someorg/somerepo/tags",
        blobs_url: "https://api.github.com/repos/someorg/somerepo/git/blobs{/sha}",
        git_tags_url: "https://api.github.com/repos/someorg/somerepo/git/tags{/sha}",
        git_refs_url: "https://api.github.com/repos/someorg/somerepo/git/refs{/sha}",
        trees_url: "https://api.github.com/repos/someorg/somerepo/git/trees{/sha}",
        statuses_url: "https://api.github.com/repos/someorg/somerepo/statuses/{sha}",
        languages_url: "https://api.github.com/repos/someorg/somerepo/languages",
        stargazers_url: "https://api.github.com/repos/someorg/somerepo/stargazers",
        contributors_url: "https://api.github.com/repos/someorg/somerepo/contributors",
        subscribers_url: "https://api.github.com/repos/someorg/somerepo/subscribers",
        subscription_url: "https://api.github.com/repos/someorg/somerepo/subscription",
        commits_url: "https://api.github.com/repos/someorg/somerepo/commits{/sha}",
        git_commits_url: "https://api.github.com/repos/someorg/somerepo/git/commits{/sha}",
        comments_url: "https://api.github.com/repos/someorg/somerepo/comments{/number}",
        issue_comment_url: "https://api.github.com/repos/someorg/somerepo/issues/comments/{number}",
        contents_url: "https://api.github.com/repos/someorg/somerepo/contents/{+path}",
        compare_url: "https://api.github.com/repos/someorg/somerepo/compare/{base}...{head}",
        merges_url: "https://api.github.com/repos/someorg/somerepo/merges",
        archive_url: "https://api.github.com/repos/someorg/somerepo/{archive_format}{/ref}",
        downloads_url: "https://api.github.com/repos/someorg/somerepo/downloads",
        issues_url: "https://api.github.com/repos/someorg/somerepo/issues{/number}",
        pulls_url: "https://api.github.com/repos/someorg/somerepo/pulls{/number}",
        milestones_url: "https://api.github.com/repos/someorg/somerepo/milestones{/number}",
        notifications_url: "https://api.github.com/repos/someorg/somerepo/notifications{?since,all,participating}",
        labels_url: "https://api.github.com/repos/someorg/somerepo/labels{/name}",
        created_at: "2013-06-03T22:34:55Z",
        updated_at: "2013-07-30T06:22:15Z",
        pushed_at: "2013-07-30T06:22:15Z",
        git_url: "git://github.com/someorg/somerepo.git",
        ssh_url: "git@github.com:someorg/somerepo.git",
        clone_url: "https://github.com/someorg/somerepo.git",
        svn_url: "https://github.com/someorg/somerepo",
        homepage: nil,
        size: 126,
        watchers_count: 0,
        language: "Ruby",
        has_issues: true,
        has_downloads: true,
        has_wiki: true,
        forks_count: 0,
        mirror_url: nil,
        open_issues_count: 0,
        forks: 0,
        open_issues: 0,
        watchers: 0,
        master_branch: "master",
        default_branch: "master",
        permissions: { admin: true }
      )
    ]
  end

  let(:token) do
    cipher = Crypto::Cipher.new
    cipher.encrypt('foobar')
  end

  context '#from_github' do
    it 'should create a new user from GitHub user data' do
      new_user = described_class.from_github(auth_hash)
      expect(new_user.persisted?).to be_true
      expect(new_user.github_id).to eq auth_hash['uid']
    end

    it 'should return an existing user if they have already registered' do
      user = User.create(github_id: 5678)
      request_user = described_class.from_github(
        { 'uid' => 5678, 'credentials' => { 'token' => 'somegibberish' } }
      )

      expect(request_user).to eq user
    end

    it 'should update the user\'s GitHub OAuth token if it has changed' do
      user = User.create(github_id: 5678, github_token: token)
      request_user = described_class.from_github(
        { 'uid' => 5678, 'credentials' => { 'token' => 'bar' } }
      )

      expect(request_user.id).to eq user.id
      expect(request_user.github_token).to_not eq user.github_token
    end

    it 'should create a new Owner for a new User' do
      new_user = described_class.from_github(auth_hash)

      owner = Owner.last

      expect(owner.github_id).to eq new_user.github_id
      expect(owner.login).to eq new_user.login
      expect(owner.name).to eq new_user.name
      expect(new_user.owners.count).to eq 1
      expect(new_user.owners.first).to eq owner
    end

    it 'should encrypt the user\'s github token' do
      new_user = described_class.from_github(auth_hash)

      expect(new_user.github_token.present?).to be_true
      expect(new_user.github_token).to_not eq auth_hash['credentials']['token']
      expect(new_user.github_token.length).to eq 40
    end
  end

  context '#sync_with_github!' do
    let(:user) do
      User.create(
        github_id: 1234,
        login: 'foo',
        github_token: token
      )
    end

    before do
      # Stub orgs call
      stub_request(:get, "https://api.github.com/user/orgs").
        with(:headers => {'Accept'=>'application/vnd.github.beta+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>"Octokit Ruby Gem #{Octokit::VERSION}"}).
        to_return(:status => 200, :body => stubbed_org_response, :headers => {})

      # Stub repos call
      stub_request(:get, "https://api.github.com/user/repos").
        with(:headers => {'Accept'=>'application/vnd.github.beta+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>"Octokit Ruby Gem #{Octokit::VERSION}"}).
        to_return(:status => 200, :body => stubbed_repo_response, :headers => {})

      # Stub org/repos call
      stub_request(:get, "https://api.github.com/users/someorg/repos").
        with(:headers => {'Accept'=>'application/vnd.github.beta+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>"Octokit Ruby Gem #{Octokit::VERSION}"}).
        to_return(:status => 200, :body => stubbed_org_repo_response, :headers => {})
    end

    it 'should create a User\'s repos and orgs from GitHub' do
      expect(user.owners.count).to eq 0
      expect(user.repos.count).to eq 0

      user.sync_with_github!

      user.reload
      expect(user.owners.count).to eq 2
      expect(user.repos.count).to eq 2
    end

    it 'should remove a User\'s repos if they no longer exist' do
      owner = Owner.create(github_id: 1, login: user.login, name: user.name)
      owner.users << user
      repo = Repo.create(owner_id: owner.id, github_id: 1, name: 'test')

      user.sync_with_github!

      expect(Repo.find_by_id(repo.id)).to be_nil
    end

    it 'should update the last_synced_at column' do
      Timecop.freeze

      expect(user.last_synced_at).to be_nil

      user.sync_with_github!

      expect(user.last_synced_at).to eq Time.now

      Timecop.return
    end

    it 'should set the syncing column to false' do
      user.update_column(:syncing, true)

      user.sync_with_github!

      expect(user.reload.syncing).to be_false
    end
  end
end
