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
      User.all.count.should eq 0

      get :create

      resp = JSON.parse response.body
      resp['status'].should eq 'success'
      User.all.count.should eq 1

      user = User.first
      session['user_id'].should eq user.id
      session['github_token'].should eq user.github_token
    end

    it 'should create a session for an existing user' do
      User.create(github_uid: '1234')
      User.all.count.should eq 1

      get :create

      resp = JSON.parse response.body
      resp['status'].should eq 'success'
      User.all.count.should eq 1

      user = User.first
      session['user_id'].should eq user.id
      session['github_token'].should eq user.github_token
    end
  end

  context '#destroy' do
    before do
      session['user_id'] = 1
      session['github_token'] = 'somegibberish'
    end

    it 'should clear a user\'s session' do
      session.any?.should be_true

      get :destroy

      session.any?.should be_false
    end
  end

end
