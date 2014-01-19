require 'spec_helper'

describe Owner do
  let(:user)  { User.create(github_id: 1, login: 'bar') }

  context '#find_or_create' do
    context 'finding an existing owner' do
      let(:owner) { Owner.create(login: 'foo') }

      it 'should find an existing owner and associate it with a User' do
        expect(user.owners.count).to eq 0

        Owner.find_or_create(owner, user)

        user.reload
        expect(user.owners.count).to eq 1
        expect(user.owners.first).to eq owner
      end

      it 'should find an existing owner and not reassociate it with a User if they have already been associated' do
        user.owners << owner
        expect(user.owners.count).to eq 1

        Owner.find_or_create(owner, user)

        user.reload
        expect(user.owners.count).to eq 1
      end
    end

    context 'creating a new Owner' do
      it 'should create a new Owner and associate it with a User' do
        owner = Hashie::Mash.new(login: 'foo', id: 1)
        expect(Owner.all.count).to eq 0

        Owner.find_or_create(owner, user)

        expect(Owner.all.count).to eq 1
        o = Owner.first
        expect(o.github_id).to eq owner.id
        expect(o.login).to eq owner.login

        user.reload
        expect(user.owners.count).to eq 1
        expect(user.owners.first).to eq o
      end
    end
  end

end
