class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.getAllUser params
  end

  def new
    @user = User.new
  end

  def show
    @microposts = User.getAllMicropost @user, params
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".txt_confirm_email"
      redirect_to root_url
    else
      render :new
    end
  end

  def edit; end

  def update
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t ".txt_account_active"
      redirect_to user
    else
      flash[:danger] = t ".txt_invalid_active_link"
      redirect_to root_url
    end
  end

  def destroy
    @user.destroy ? flash[:success] = t(".detele_success") :
      flash[:warning] = t(".detele_error")
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t ".txt_login_false"
      redirect_to login_url
    end
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:warning] = t ".user_not_found"
      redirect_to root_url
    end
  end

  def correct_user
    redirect_to root_url unless current_user? @user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end
end
