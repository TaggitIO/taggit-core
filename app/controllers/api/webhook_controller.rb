class Api::WebhookController < ApplicationController

  before_action :verify_remote_host

  # Public: Processes a webhook payload from GitHub.
  #
  # POST /webhook
  def process_payload
    payload = params['release']
    repo = Repo.find_by(github_id: params['repository']['id'])

    render nothing: true, status: :forbidden and return if repo.inactive?

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

  private

  def verify_remote_host
    range = IPAddr.new('192.30.252.0/22')
    render nothing: true, status: :forbidden unless range === request.remote_ip
  end

  # Private: Returns the allowed HTTP methods for this controller's actions.
  def allowed_methods
    'POST'
  end

end
