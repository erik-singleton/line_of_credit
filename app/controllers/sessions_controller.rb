class SessionsController < ApplicationController
  def create
    user = User.find_or_create_by!(email: params[:email])
    session[:user] = user.id

    render json: { success: true }
  end

  def destroy
    reset_session

    redirect_to home_path
  end
end
