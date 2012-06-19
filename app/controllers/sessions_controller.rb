class SessionsController < ApplicationController
	def create
		if params.has_key?(:session)
			@user = User.find_by_email(params[:session][:email])
			if @user && @user.authenticate(params[:session][:password]) # authenticate method created by has_secure_password in model
				sign_in @user # defined in sessions_helper
			else
				@user = {error: 'invalid email/password'}
			end
      render json: @user
		elsif request.env['omniauth.auth']
	  	omniauth = request.env["omniauth.auth"]
	  	# render :text => request.env["omniauth.auth"].to_yaml
			@user = User.find_or_create_by_uid(omniauth[:uid])
			Rails.logger.info(@user.errors.inspect) 
			@user.username ||= "#{omniauth[:info][:first_name]} #{omniauth[:info][:last_name]}" # TODO: truncate last name to first letter
			@user.email ||= omniauth[:info][:email]
			@user.password ||= @user.password_confirmation ||= SecureRandom.base64 # Unused but needed to pass validation
			@user.token = omniauth[:credentials][:token]
			@user.save
			sign_in @user
			redirect_to "/access_token/#{@user.token}"
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
