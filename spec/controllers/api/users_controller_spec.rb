require 'spec_helper'

describe API::UsersController do
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
      get :show

      response = json['user']
      expect(response['id']).to eq user.id
      expect(response['login']).to eq user.login
      expect(response['name']).to eq user.name
      expect(response['email']).to eq user.email
    end

    it 'should respond with user repo details' do
      2.times do |i|
        Repo.create(owner_id: owner.id, github_id: i, name: "Repo#{i}", full_name: "foo/Repo#{i}")
      end

      get :show

      response = json['user']
      expect(response['repos'].count).to eq 2
    end
  end

  context '#update' do
    it 'should let the user update their email' do
      put :update, { email: 'foo+1@bar.com' }

      expect(user.reload.email).to eq 'foo+1@bar.com'
    end

    it 'should not accept any other parameters' do
      put :update, { name: 'Foos' }

      expect(user.reload.name).to eq 'Foo Bar'
    end

    it 'should respond with the user\'s data' do
      put :update, { email: 'foo+1@bar.com' }

      expect(json['user']['email']).to eq 'foo+1@bar.com'
    end
  end
end
