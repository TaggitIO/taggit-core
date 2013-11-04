class SubscriptionsController < ApplicationController

  before_filter :set_repo

  def create
    email = params[:email]
    subscription = Subscription.create!(repo_id: @repo.id, email: email)

    render json: subscription
  end

  def destroy
    subscription = @repo.subscriptions.find(params[:id])
    subscription.destroy!

    render json: { status: 'success'}
  end

end
