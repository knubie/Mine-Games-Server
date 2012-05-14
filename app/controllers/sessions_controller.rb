class SessionsController < ApplicationController
	def new
	end

	def create
		if params.has_key?(:session)
			user = User.find_by_email(params[:session][:email])
			if user && user.authenticate(params[:session][:password]) # authenticate method created by has_secure_password in model
				# user.token = SecureRandom.urlsafe_base64
				# user.save
				sign_in user # defined in sessions_helper
				redirect_to user
			else
				flash.now[:error] = 'Invalid email and/or password'
				render 'new'
			end
		elsif request.env['omniauth.auth']
	  	omniauth = request.env["omniauth.auth"]
	  	# render :text => request.env["omniauth.auth"].to_yaml
			user = User.find_or_create_by_uid_and_email_and_username(
				omniauth[:uid],
				omniauth[:info][:email],
				"#{omniauth[:info][:first_name]} #{omniauth[:info][:last_name]}",
			)
			Rails.logger.info(user.errors.inspect) 
			user.token = omniauth[:credentials][:token]
			user.save
			sign_in user
			redirect_to user
		else
			flash.now[:error] = 'Invalid email and/or password'
			render 'new'
		end
	end

	def destroy
		sign_out
		redirect_to root_path
	end
end
