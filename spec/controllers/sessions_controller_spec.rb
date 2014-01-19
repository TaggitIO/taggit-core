require 'spec_helper'

describe SessionsController do

  context '#create' do
    before do
      request.env['omniauth.auth'] = {
        'uid' => '1234',
        'info' => {
          'nickname' => 'foobar',
          'name' =>     'Foo Bar',
        },
        'credentials' => { 'token' => 'somegibberish' },
        'extra' => { 'raw_info' => { 'gravatar_id' => 'moregibberish' } }
      }
    end

    it 'should create a session for a new user' do
      expect(User.all.count).to eq 0

      get :create

      resp = json
      expect(resp['status']).to eq 'success'
      expect(User.all.count).to eq 1

      user = User.first
      expect(session['user_id']).to eq user.id
      expect(session['github_token']).to eq user.github_token
    end

    it 'should create a session for an existing user' do
      User.create(github_id: '1234')
      expect(User.all.count).to eq 1

      get :create

      resp = json
      expect(resp['status']).to eq 'success'
      expect(User.all.count).to eq 1

      user = User.first
      expect(session['user_id']).to eq user.id
      expect(session['github_token']).to eq user.github_token
    end
  end

  context '#destroy' do
    before do
      session['user_id'] = 1
      session['github_token'] = 'somegibberish'
    end

    it 'should clear a user\'s session' do
      expect(session.any?).to be_true

      get :destroy

      expect(session.any?).to be_false
    end
  end

end
