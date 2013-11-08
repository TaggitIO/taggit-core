class WebhookController < ApplicationController

  # Public: Processes a webhook payload from GitHub.
  #
  # POST /webhook
  def process_payload
    payload = params['release']
    repo = Repo.find_by(github_id: params['repository']['id'])

    release = Release.new(
      repo_id:      repo.id,
      github_id:    payload['id'],
      html_url:     payload['html_url'],
      tag_name:     payload['tag_name'],
      body:         payload['body'],
      prerelease:   payload['prerelease'],
      published_at: Time.iso8601(payload['published_at'])
    )

    if release.save
      render nothing: true, status: :created
    else
      render nothing: true, status: :bad_request
    end
  end

end
