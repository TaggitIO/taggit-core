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

  context '#from_github' do
    it 'should create a new user from GitHub user data' do
      new_user = described_class.from_github(auth_hash)
      new_user.persisted?.should be_true
      new_user.github_uid.should eq auth_hash['uid']
    end

    it 'should return an existing user if they have already registered' do
      user = User.create(github_uid: 5678)
      request_user = described_class.from_github(
        { 'uid' => 5678, 'credentials' => { 'token' => 'somegibberish' } }
      )

      request_user.should eq user
    end

    it 'should update the user\'s GitHub OAuth token if it has changed' do
      user = User.create(github_uid: 5678, github_token: 'foo')
      request_user = described_class.from_github(
        { 'uid' => 5678, 'credentials' => { 'token' => 'bar' } }
      )

      request_user.id.should eq user.id
      request_user.github_token.should eq 'bar'
    end
  end
end
