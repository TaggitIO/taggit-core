require 'spec_helper'

describe Repo do
  let(:token) { Crypto::Cipher.encrypt('foobar') }
  let(:user)  { User.create(github_id: 1, github_token: token, login: 'foobar') }
  let(:repo)  { Repo.create(github_id: 1, name: 'test', full_name: 'foobar/test', active: false)}

  # For building sample response
  let(:agent) { Sawyer::Agent.new('foo')}

  context '#activate' do
    before do
      stub_request(:post, "https://api.github.com/repos/foobar/test/hooks").
        with(:body => "{\"name\":\"web\",\"config\":{\"url\":\"#{Constants::HOOK_URL}\",\"content_type\":\"json\"},\"events\":[\"release\"],\"active\":true}",
             :headers => {'Accept'=>'application/vnd.github.beta+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token foobar', 'User-Agent'=>"Octokit Ruby Gem #{Octokit::VERSION}"}).
        to_return(:status => 200, :body => Sawyer::Resource.new(agent, {id: 1}), :headers => {})
    end

    it 'should activate a repo' do
      repo.activate!(user)
      expect(repo.reload.active).to be_true
    end

    it 'should set the hook id' do
      repo.activate!(user)
      expect(repo.reload.github_hook_id).to eq 1
    end

    it 'should do nothing if the repo is already active' do
      repo.active = true
      repo.save

      expect(repo.activate!(user)).to be_false
    end
  end

  context '#deactivate!' do
    before do
      repo.active = true
      repo.github_hook_id = 1
      repo.save

      stub_request(:delete, "https://api.github.com/repos/foobar/test/hooks/1").
        with(:body => "{}",
             :headers => {'Accept'=>'application/vnd.github.beta+json', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'Authorization'=>'token foobar', 'User-Agent'=>"Octokit Ruby Gem #{Octokit::VERSION}"}).
        to_return(:status => 200, :body => "", :headers => {})
    end

    it 'should deactivate a repo' do
      expect(repo.active).to be_true
      repo.deactivate!(user)

      expect(repo.reload.active).to be_false
    end

    it 'should remove the hook id' do
      expect(repo.github_hook_id).to eq 1
      repo.deactivate!(user)

      expect(repo.reload.github_hook_id).to be_nil
    end

    it 'should do nothing if the repo is already deactivated' do
      repo.active = false
      repo.save

      expect(repo.deactivate!(user)).to be_false
    end
  end

  context '#inactive?' do
    it 'should return false if the Repo is active' do
      repo.active = true
      repo.save

      expect(repo.inactive?).to be_false
    end

    it 'should return true if the Repo is inactive' do
      expect(repo.inactive?).to be_true
    end
  end
end
