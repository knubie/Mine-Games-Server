module SessionsHelper
	def sign_in(user)
		cookies.permanent[:token] = user.token
		current_user = user
	end

	def sign_out
		current_user = nil
		cookies.delete :token
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		@current_user ||= User.find_by_token(cookies[:token]) unless cookies[:token].nil?
	end
end
