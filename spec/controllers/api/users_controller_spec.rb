require 'spec_helper'

describe Api::UsersController do
  let(:user) { User.create(github_id: 1, login: 'foo', name: 'Foo Bar', email: 'foo@bar.com') }
  let(:owner) { Owner.create(github_id: 1, login: 'foo',  name: 'Foo') }

  before do
    user.owners << owner
    user.save!

    session['user_id'] = 1
    session['github_token'] = 'somegibberish'
  end

  context '#show' do
    it 'should respond with the user details' do
      get :show, id: 'singleton'

      response = json['user']
      expect(response['id']).to eq user.id
      expect(response['login']).to eq user.login
      expect(response['name']).to eq user.name
      expect(response['email']).to eq user.email
    end

    it 'should respond with a 401 when the user is not logged in' do
      session['user_id'] = nil

      expect { get :show, id: 'singleton' }.to raise_error Errors::UnauthorizedError
    end
  end

  context '#update' do
    it 'should let the user update their email' do
      put :update, { id: 'singleton', email: 'foo+1@bar.com' }

      expect(user.reload.email).to eq 'foo+1@bar.com'
    end

    it 'should not accept any other parameters' do
      put :update, { id: 'singleton', name: 'Foos' }

      expect(user.reload.name).to eq 'Foo Bar'
    end

    it 'should respond with the user\'s data' do
      put :update, { id: 'singleton', email: 'foo+1@bar.com' }

      expect(json['user']['email']).to eq 'foo+1@bar.com'
    end
  end

  context '#sync' do
    before do
      @current_user = user
      @current_user.stub(:sync_with_github!).and_return(true)
      controller.stub(:current_user).and_return(@current_user)
    end

    it 'should sync repos for a user from GitHub' do
      expect(@current_user).to receive(:sync_with_github!)

      post :sync, { id: 'singleton' }
    end

    it 'should respond with repo data' do
      2.times do |i|
        Repo.create(owner_id: owner.id, github_id: i, name: "bar#{i}")
      end

      post :sync, { id: 'singleton' }

      resp = json['repos']
      expect(resp.count).to eq 2
    end
  end
end
