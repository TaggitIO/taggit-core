class Api::ReleasesController < ApplicationController
  def index
    releases = Release.all.order("id DESC").limit(6)
    render json: releases
  end
end
