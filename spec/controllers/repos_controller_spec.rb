require 'spec_helper'

describe ReposController do

  before do
    @owner = Owner.create(github_id: 1234, login: 'foo')
    @repo1 = Repo.create(github_id: 1, name: 'bar', owner_id: @owner.id)
    @repo2 = Repo.create(github_id: 2, name: 'baz', owner_id: @owner.id)
  end

  context '#index' do
    it 'should respond with Repos data for the specified Owner' do
      get :index, { owner_id: @owner.login }

      resp = JSON.parse(response.body)
      resp.count.should eq 2
    end

    it 'should raise a 404 if the Owner is not found' do
      expect { get :index, { owner_id: 'nogood' } }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  context '#show' do
    it 'should respond with Repo data for the specified Owner and Repo' do
      get :show, { owner_id: @owner.login, id: @repo1.name }

      resp = JSON.parse(response.body)
      resp['id'].should eq @repo1.id
    end

    it 'should raise a 404 if the Owner is not found' do
      expect { get :show, { owner_id: 'nogood', id: @repo1.name } }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'should raise a 404 if the Repo is not found' do
      expect { get :show, { owner_id: @owner.login, id: 'nogood' } }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
