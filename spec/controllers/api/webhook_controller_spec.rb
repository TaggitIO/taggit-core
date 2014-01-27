require 'spec_helper'

describe Api::WebhookController do
  context '#process' do
    let(:owner) { Owner.create(github_id: 1, login: 'foo', name: 'Foo') }
    let(:repo)  { Repo.create(github_id: 1, owner_id: owner.id, name: 'Bar', full_name: 'foo/Bar', active: true) }
    
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

    before do
      @request.env['REMOTE_ADDR'] = '192.30.252.1'
    end

    it 'should create a new Release object for a Repo with the supplied data' do
      post :process_payload, params

      expect(response.status).to eq 201

      payload = params[:release]

      r = Release.last
      expect(r.github_id).to eq payload[:id]
      expect(r.html_url).to eq payload[:html_url]
      expect(r.tag_name).to eq payload[:tag_name]
      expect(r.body).to eq payload[:body]
      expect(r.prerelease).to be_false
      expect(r.published_at).to eq Time.iso8601(payload[:published_at])
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

      expect(response.status).to eq 400
    end

    it 'should respond with a 403 if the Repo is inactive' do
      repo.active = false
      repo.save

      post :process_payload, params

      expect(response.status).to eq 403
    end

    it 'should respond with a 403 if the request did not originate from GitHub' do
      @request.env['REMOTE_ADDR'] = '0.0.0.0'
      post :process_payload, params

      expect(response.status).to eq 403
    end
  end
end
