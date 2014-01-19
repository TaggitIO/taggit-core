require 'spec_helper'

describe Release do
  let(:owner) { Owner.create(github_id: 1, login: 'foo', name: 'Foo') }
  let(:repo)  { Repo.create(github_id: 1, owner_id: owner.id, name: 'Bar', full_name: 'foo/Bar') }
  let!(:sub)   { Subscription.create(repo_id: repo.id, email: 'foo@bar.com') }
  let(:release) { Release.new(repo_id: repo.id, github_id: 1, html_url: 'https://github.com/foo/bar/releases/v1.0.0', tag_name: 'v1.0.0', body: 'Woohoo! V1!', prerelease: false, published_at: Time.now) }

  context '#send_release_notification' do
    it 'should send a release notification to subscribers' do
      ENV['MANDRILL_APIKEY'] = 'somenonsense'
      stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send.json").
         with(:body => "{\"message\":{\"subject\":\"New Release: Bar v1.0.0\",\"from_name\":\"Taggit\",\"text\":\"Bar has created release v1.0.0\\n\\nYou can see the release details here: https://github.com/foo/bar/releases/v1.0.0\",\"to\":[{\"email\":\"foo@bar.com\"}],\"html\":\"Bar has created release v1.0.0\\n\\nYou can see the release details here: https://github.com/foo/bar/releases/v1.0.0\",\"from_email\":\"noreply@taggit.io\"},\"async\":false,\"ip_pool\":null,\"send_at\":null,\"key\":\"somenonsense\"}",
              :headers => {'Content-Type'=>'application/json', 'Host'=>'mandrillapp.com:443', 'User-Agent'=>'excon/0.28.0'}).
         to_return(:status => 200, :body => [{email: 'foo@bar.com', status: 'sent', _id: 'somehash', reject_reason: nil}].to_json, :headers => {})

      status = release.send_release_notification.first
      expect(status['email']).to eq sub.email
      expect(status['status']).to eq 'sent'
    end

    it 'should not send anything if there are no subscribers' do
      sub.delete

      status = release.send_release_notification
      expect(status).to be_nil
    end
  end

  context '#message' do
    it 'should build a message hash with the appropriate parameters' do
      release.instance_variable_set(:@repo, repo)
      release.instance_variable_set(:@subscriptions, repo.subscriptions)

      release.instance_variable_get(:@subscriptions)
      m = release.instance_eval { message }

      expect(m[:subject]).to eq 'New Release: Bar v1.0.0'
      expect(m[:from_name]).to eq 'Taggit'
      expect(m[:text]).to eq "Bar has created release v1.0.0\n\nYou can see the release details here: https://github.com/foo/bar/releases/v1.0.0"
      expect(m[:to]).to eq [{email: sub.email}]
      expect(m[:html]).to eq m[:text]
      expect(m[:from_email]).to eq 'noreply@taggit.io'
    end
  end
end
