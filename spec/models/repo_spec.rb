require 'spec_helper'

describe Repo do
  let(:user)  { User.create(github_id: 1, github_token: 'gibberish', login: 'foobar') }
  let(:repo)  { Repo.create(github_id: 1, name: 'test', full_name: 'foobar/test', active: true)}

  context '#create_hook!' do
    before do
      stub_request(:post, "https://api.github.com/repos/foobar/test/hooks").
         with(:body => "{\"name\":\"web\",\"config\":{\"url\":\"#{Constants::HOOK_URL}\",\"content_type\":\"json\"},\"events\":[\"release\"],\"active\":true}",
              :headers => {'Accept'=>'application/vnd.github.beta+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token gibberish', 'User-Agent'=>"Octokit Ruby Gem #{Octokit::VERSION}"}).
         to_return(:status => 200, :body => "", :headers => {})
    end

    it 'should create a new webhook for the repo' do
      repo.create_hook!(user)
    end
  end
end
