require 'mandrill'

class Release < ActiveRecord::Base
  belongs_to :repo

  validates :github_id, uniqueness: true

  after_create :send_release_notification

  # Public: Sends an API request to Mandrill to notify subscribers of the
  # release.
  #
  # TODO: Refactor to utilize the mandrill gem's template class.
  def send_release_notification
    @repo = repo
    @subscriptions = @repo.subscriptions

    return if @subscriptions.none?

    client = Mandrill::API.new

    client.messages.send message
  end

  private

  # Private: Builds the message hash.
  #
  # Returns: A Hash with the required parameters to send to the Mandrill API.
  def message
    {
      subject:    subject,
      from_name:  Constants::MANDRILL_FROM_NAME,
      text:       text_body,
      to:         recipients,
      html:       html_body,
      from_email: Constants::MANDRILL_FROM_EMAIL 
    }
  end

  # Private: Builds the subject string for an email.
  def subject
    "New Release: #{@repo.name} #{tag_name}"
  end

  # Private: Assembles a list of recipients
  def recipients
    @subscriptions.inject([]) { |arr, sub| arr << { email: sub.email } }
  end

  # Private: The plaintext body of the email.
  #
  # Returns: The plaintext body of the email.
  def text_body
    "#{@repo.name} has created release #{tag_name}\n\nYou can see the release details here: #{html_url}"
  end

  # Private: The HTML body of the email. Not yet implemented and is likely to
  # be replaced in lieue of the mandrill gem's Template class.
  #
  # Returns: The HTML Body of the email.
  def html_body
    text_body
  end

end
