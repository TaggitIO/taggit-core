Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV['TAGGIT_GITHUB_KEY'], ENV['TAGGIT_GITHUB_SECRET'], scope: 'public_repo'
end