require 'spec_helper'

describe OwnersController do
  context '#show' do
    it 'should respond with Owner details' do
      owner = Owner.create(github_id: 1234, login: 'foo', name: 'Foo Bar')

      get :show, { id: owner.login }

      resp = JSON.parse(response.body)
      resp['login'].should eq owner.login
      resp['github_id'].should eq owner.github_id
      resp['id'].should eq owner.id
      resp['name'].should eq owner.name
    end

    it 'should respond with Owner details if the ID param has a different case' do
      owner = Owner.create(github_id: 1234, login: 'Foo', name: 'Foo Bar')

      get :show, { id: 'foo' }

      resp = JSON.parse(response.body)
      resp['id'].should eq owner.id
    end
  end
end
