class HomeController < ApplicationController
  def index
  	omniauth = request.env["omniauth.auth"]
  	# render :text => request.env["omniauth.auth"].to_yaml
  end
end
