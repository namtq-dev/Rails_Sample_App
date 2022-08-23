class PasswordResetsController < ApplicationController
  before_action :get_user, :valid_user, :check_expiration,
                only: %i(edit update)

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t(".email_pass_reset_instructions")
      redirect_to root_url
    else
      flash.now[:danger] = t(".email_not_found")
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, t(".empty_pass"))
      render :edit
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = t(".updated")
      redirect_to @user
    else
      update_failed
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def update_failed
    flash.now[:danger] = t(".update_failed")
    render :edit
  end

  # Before filters
  def get_user
    @user = User.find_by(email: params[:email])
    return if @user

    flash[:danger] = t("invalid_user")
    redirect_to root_path
  end

  # Confirms a valid user.
  def valid_user
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    flash[:danger] = t(".invalid_user")
    redirect_to root_url
  end

  # Checks expiration of reset token.
  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t(".password_reset_expired")
    redirect_to new_password_reset_url
  end
end
