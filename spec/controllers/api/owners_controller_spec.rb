require 'spec_helper'

describe API::OwnersController do
  context '#show' do
    it 'should respond with Owner details' do
      owner = Owner.create(github_id: 1234, login: 'foo', name: 'Foo Bar')

      get :show, { id: owner.login }

      resp = json['owner']
      expect(resp['login']).to eq owner.login
      expect(resp['github_id']).to eq owner.github_id
      expect(resp['id']).to eq owner.id
      expect(resp['name']).to eq owner.name
    end

    it 'should respond with Owner details if the ID param has a different case' do
      owner = Owner.create(github_id: 1234, login: 'Foo', name: 'Foo Bar')

      get :show, { id: owner.login.downcase }

      resp = json['owner']
      expect(resp['id']).to eq owner.id
    end

    it 'should raise a 404 if the Owner is not found' do
      expect { get :show, { id: 'nogood' } }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
