class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from ActiveRecord::RecordNotFound, with: :render_json_404

  before_filter :set_user

  def set_user
    if session[:user].present?
      @user = User.find(session[:user])
    end
  end

  def require_login
    render json: { error: 'unauthorized' }, status: :unauthorized unless @user
  end

  def render_json_404
    render json: { error: 'not found' }, status: :not_found
  end
end
