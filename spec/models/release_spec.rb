require 'spec_helper'

describe Release do
  context '#send_release_notification' do
    let(:owner) { Owner.create(github_id: 1, login: 'foo', name: 'Foo') }
    let(:repo)  { Repo.create(github_id: 1, owner_id: owner.id, name: 'Bar', full_name: 'foo/Bar') }
    let(:sub)   { Subscription.create(repo_id: repo.id, email: 'foo@bar.com') }
    let(:release) { Release.new(repo_id: repo.id, github_id: 1, html_url: 'https://github.com/foo/bar/releases/v1.0.0', tag_name: 'v1.0.0', body: 'Woohoo! V1!', prerelease: false, published_at: Time.now) }

    before do
      # Stupid let statements
      sub

      stub_request(:post, "https://mandrillapp.com/api/1.0/messages/send.json").
         with(:body => "{\"message\":{\"subject\":\"New Release: Bar v1.0.0\",\"from_name\":\"Taggit\",\"text\":\"Bar has created release v1.0.0\\n\\nYou can see the release details here: https://github.com/foo/bar/releases/v1.0.0\",\"to\":[{\"email\":\"foo@bar.com\"}],\"html\":\"Bar has created release v1.0.0\\n\\nYou can see the release details here: https://github.com/foo/bar/releases/v1.0.0\",\"from_email\":\"noreply@taggit.io\"},\"async\":false,\"ip_pool\":null,\"send_at\":null,\"key\":\"AFYHBUB3RDG7wqgk19VJBA\"}",
              :headers => {'Content-Type'=>'application/json', 'Host'=>'mandrillapp.com:443', 'User-Agent'=>'excon/0.28.0'}).
         to_return(:status => 200, :body => [{email: 'foo@bar.com', status: 'sent', id: 'somehash', reject_reason: nil}].to_json, :headers => {})
    end

    it 'should send a release notification to all subscribers' do
      status = release.send_release_notification

      status = status.first
      status['email'].should eq sub.email
      status['status'].should eq 'sent'
    end

    it 'should not send a release notification unsubscribed subscribers' do
      sub = Subscription.create(repo_id: nil, email: 'foo+1@bar.com')

      status = release.send_release_notification
      status.collect { |stat| stat[:email] }.include?('foo+1@bar.com').should be_false
    end

    it 'should not send anything if there are no subscribers' do
      sub.delete

      status = release.send_release_notification
      status.should be_nil
    end
  end
end
