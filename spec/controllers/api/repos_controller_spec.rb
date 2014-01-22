require 'spec_helper'

describe Api::ReposController do

  let(:owner)  { Owner.create(github_id: 1234, login: 'foo') }
  let!(:repo1) { Repo.create(github_id: 1, name: 'bar', full_name: 'foo/bar', owner_id: owner.id) }
  let!(:repo2) { Repo.create(github_id: 2, name: 'baz', full_name: 'foo/baz', owner_id: owner.id) }

  context '#index' do
    it 'should respond with Repos data for the specified Owner' do
      get :index, { owner: owner.login }

      resp = json['repos']
      expect(resp.count).to eq 2
    end

    it 'should raise a 404 if the Owner is not found' do
      expect { get :index, { owner: 'foo/nogood' } }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  context '#show' do
    it 'should respond with Repo data for the specified Owner and Repo' do
      get :show, { id: repo1.full_name }

      resp = json['repo']
      expect(resp['id']).to eq repo1.id
    end

    it 'should raise a 404 if the Repo is not found' do
      expect { get :show, { id: 'foo/nogood' } }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  context '#update' do

    let!(:user) { User.create(github_id: 12, login: 'foo') }

    before do
      user.owners << owner

      session[:user_id] = user.id
    end

    it 'should update the model attributes' do
      put :update, {
        id: repo1.full_name,
        active: true
      }

      expect(repo1.reload.active).to be_true

      resp = json['repo']
      expect(resp['id']).to eq repo1.id
    end

    it 'should raise a 404 if the current user is not authorized to access the Repo' do
      user2 = User.create(github_id: 23, login: 'bar')
      session[:user_id] = user2.id

      expect do
        put :update, {
          id: repo1.full_name,
          active: true
        }
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
