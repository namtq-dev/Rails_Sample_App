class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :find_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @pagy, @users = pagy(User.all, page: params[:page],
                                  items: Settings.pagy.items_per_page)
  end

  def show
    redirect_to root_url and return unless @user.activated?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = t(".check_mail")
      redirect_to root_url
    else
      flash.now[:danger] = t(".error")
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = t(".update_success")
      redirect_to @user
    else
      flash[:danger] = t(".update_fail")
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t(".del_success")
    else
      flash[:danger] = t(".del_fail")
    end
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  # Before filters

  # Confirms a logged-in user.
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t(".not_login")
    redirect_to login_url
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t(".invalid_user")
    redirect_to root_path
  end

  # Confirms the correct user.
  def correct_user
    redirect_to(root_url) unless current_user?(@user)
  end

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
