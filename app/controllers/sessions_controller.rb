class SessionsController < ApplicationController
  before_filter :should_not_be_signed_in,  only: [:new, :create]  # Outgrowth of Ex 9.6.5


  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def new
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
