class Subscription < ActiveRecord::Base
  belongs_to :repo

  validates :email, uniqueness: { scope: :repo_id, 
    message: 'This email has already subscribed to the Repo.' }
end
