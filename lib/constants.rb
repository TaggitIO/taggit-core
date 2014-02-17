module Constants
  FRONTEND_URL              = ENV['TAGGIT_FRONTEND_URL']
  HOOK_URL                  = ENV['TAGGIT_HOOK_URL']

  MANDRILL_FROM_NAME        = 'Taggit'
  MANDRILL_FROM_EMAIL       = 'noreply@taggit.io'
  MANDRILL_RELEASE_TEMPLATE = 'release'
end
