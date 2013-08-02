require 'spec_helper'

describe Owner do
  let(:user)  { User.create(github_id: 1, login: 'bar') }

  context '#find_or_create' do
    context 'finding an existing owner' do
      let(:owner) { Owner.create(login: 'foo') }

      it 'should find an existing owner and associate it with a User' do
        user.owners.count.should eq 0

        Owner.find_or_create(owner, user)

        user.reload
        user.owners.count.should eq 1
        user.owners.first.should eq owner
      end

      it 'should find an existing owner and not reassociate it with a User if they have already been associated' do
        user.owners << owner
        user.owners.count.should eq 1

        Owner.find_or_create(owner, user)

        user.reload
        user.owners.count.should eq 1
      end
    end

    context 'creating a new Owner' do
      it 'should create a new Owner and associate it with a User' do
        owner = Hashie::Mash.new(login: 'foo', id: 1)
        Owner.all.count.should eq 0

        Owner.find_or_create(owner, user)

        Owner.all.count.should eq 1
        o = Owner.first
        o.github_id.should eq owner.id
        o.login.should eq owner.login

        user.reload
        user.owners.count.should eq 1
        user.owners.first.should eq o
      end
    end
  end

end
