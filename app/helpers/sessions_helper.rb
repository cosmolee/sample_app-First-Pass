module SessionsHelper

  def sign_in(user)
    #cookies.permanent.signed[:remember_token] = user.remember_token
    # See note in ~/spec/support/utilities.rb for why I'm not using "signed" cookies here (breaks rspec tests).
    cookies.permanent[:remember_token] = user.remember_token
    current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def current_user?(user)
    user == current_user
  end

  def sign_out
    cookies.delete(:remember_token)
  end

# 3/6/2012
# Listing 9.18.  Seems like the parameter is badly named.  There's no default set, rather the arg is required.  
# If the method is called w/o an arg it dies at runtime - FAIL.
# A default would be something assigned if there wasn't anything otherwise given.  I'm setting a default so if the method is called w/o an arg, it will go to a specified default.
# Need to test for this change, ie, when redirect_back_or() is called w/o an argument.
  #  def redirect_back_or(default)


  def redirect_back_or(default = "/help")
    redirect_to(session[:return_to] || default)
    clear_return_to
  end


  def store_location
    session[:return_to] = request.fullpath
  end


  private

    def user_from_remember_token
      #remember_token = cookies.signed[:remember_token]
      # See note in ~/spec/support/utilities.rb for why I'm not using "signed" cookies here (breaks rspec tests).
      remember_token = cookies[:remember_token]
      User.find_by_remember_token(remember_token) unless remember_token.nil?
    end

    def clear_return_to
      session.delete(:return_to)
    end


end
