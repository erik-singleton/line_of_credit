class UserController < ApplicationController
  def create
    begin
      user = User.find_or_create_by!(email: params[:email])

      render json: { success: true }
    rescue ActiveRecord::RecordInvalid
      render json: { error: 'invalid email' },
             status: :conflict
    end
  end
end
