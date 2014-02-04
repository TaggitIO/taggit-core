require 'mandrill'

class Release < ActiveRecord::Base
  belongs_to :repo

  validates :github_id, uniqueness: true

  after_create :send_release_notification

  # Public: Sends an API request to Mandrill to notify subscribers of the
  # release.
  def send_release_notification
    @repo = repo
    @subscriptions = @repo.subscriptions.includes(:user)

    return if @subscriptions.none?

    client = Mandrill::API.new

    client.messages.send_template(
      Constants::MANDRILL_RELEASE_TEMPLATE,
      template,
      message
    )
  end

  private

  # Private: Builds the message hash.
  #
  # Returns: A Hash with the required parameters to send to the Mandrill API.
  def message
    {
      subject:    subject,
      from_name:  Constants::MANDRILL_FROM_NAME,
      to:         recipients,
      from_email: Constants::MANDRILL_FROM_EMAIL,
      global_merge_vars: [
        {
          name:    'HTML_URL',
          content: html_url
        }
      ]
    }
  end

  # Private: Builds the template array.
  #
  # Returns: An Array with the template data to send to Mandrill.
  def template
    [
      {
        name:    'tag_name',
        content: tag_name,
      },
      {
        name:    'repo_name',
        content: @repo.full_name
      },
      {
        name:    'body',
        content: body
      },
      {
        name:    'prerelease',
        content: prerelease? ? 'Yes' : 'No'
      },
      {
        name:    'published_at',
        content: published_at.strftime('%m/%d/%Y %H:%m %Z')
      }
    ]
  end

  # Private: Builds the subject string for an email.
  def subject
    "New Release: #{@repo.name} #{tag_name}"
  end

  # Private: Assembles a list of recipients
  def recipients
    @subscriptions.inject([]) do |arr, sub|
      arr << { email: sub.email, name: sub.user.name }
    end
  end
end
