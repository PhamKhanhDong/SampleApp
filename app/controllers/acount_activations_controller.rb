class AcountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute :activated, true
      user.update_attribute :activated_at, Time.zone.now
      log_in user
      flash[:success] = t ".acount_success"
      redirect_to user
    else
      flash[:danger] = t ".acount_danger"
      redirect_to root_url
    end
  end
end
