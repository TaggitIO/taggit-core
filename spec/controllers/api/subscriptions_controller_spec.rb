require 'spec_helper'

describe Api::SubscriptionsController do
  let(:user)  { User.create(github_id: 1, login: 'foo', name: 'Foo Bar', email: 'foo@bar.com') }
  let(:owner) { Owner.create(github_id: 1, login: 'foo', name: 'Foo') }
  let(:repo)  { Repo.create(github_id: 1, owner_id: owner.id, name: 'Bar', full_name: 'foo/Bar') }
  let!(:sub)  { Subscription.create(repo_id: repo.id, email: 'foo@bar.com') }

  before do
    session['user_id'] = user.id
    session['github_token'] = 'somegibberish'
  end

  context '#create' do
    it 'should create a new subscription for a repo' do
      email = 'foo+1@bar.com'
      post :create, repo: repo.full_name, email: email

      expect(user.subscriptions.last.email).to eq email
    end

    it 'should raise an error if the email has already subscribed to the repo' do
      expect do
        post :create, repo: repo.full_name, email: 'foo@bar.com'
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end

  context '#destroy' do
    it 'should remove the subscription' do
      user.subscriptions << sub
      user.save!

      expect(user.subscriptions.count).to eq 1

      delete :destroy, id: sub.id

      expect(user.subscriptions.count).to eq 0
    end
  end
end
