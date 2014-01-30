Rails.application.config.middleware.use Temescal::Middleware do |config|
  config.ignored_errors = Errors::TaggitError, ActiveRecord::RecordNotFound
end
