require 'spec_helper'

describe WebhookController do
  context '#process' do
    let(:owner) { Owner.create(github_id: 1, login: 'foo', name: 'Foo') }
    let(:repo)  { Repo.create(github_id: 1, owner_id: owner.id, name: 'Bar', full_name: 'foo/Bar') }
    
    let(:params) do
      {
        release: {
          url: "https://api.github.com/repos/foo/bar/releases/1",
          html_url: "https://github.com/foo/bar/releases/v1.0.0",
          assets_url: "https://api.github.com/repos/foo/bar/releases/1/assets",
          upload_url: "https://uploads.github.com/repos/foo/bar/releases/1/assets{?name}",
          id: 1,
          tag_name: "v1.0.0",
          target_commitish: "master",
          name: "v1.0.0",
          body: "Description of the release",
          draft: false,
          prerelease: false,
          created_at: "2013-02-27T19:35:32Z",
          published_at: "2013-02-27T19:35:32Z",
        },
        repository: { id: repo.github_id },
        action: 'published'
      }
    end

    it 'should create a new Release object for a Repo with the supplied data' do
      post :process_payload, params

      response.status.should eq 201

      payload = params[:release]

      r = Release.last
      r.github_id.should eq payload[:id]
      r.html_url.should eq payload[:html_url]
      r.tag_name.should eq payload[:tag_name]
      r.body.should eq payload[:body]
      r.prerelease.should be_false
      r.published_at.should eq Time.iso8601(payload[:published_at])
    end

    it 'should respond with a 400 if the Release has already been created' do
      payload = params[:release]
      Release.create(
        repo_id:      repo.id,
        github_id:    payload[:id],
        html_url:     payload[:html_url],
        tag_name:     payload[:tag_name],
        body:         payload[:body],
        prerelease:   payload[:prerelease],
        published_at: Time.iso8601(payload[:published_at])
      )

      post :process_payload, params

      response.status.should eq 400
    end
  end
end
