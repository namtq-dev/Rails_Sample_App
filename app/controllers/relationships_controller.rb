class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :find_user, only: %i(following followers)
  before_action :find_user_for_create, only: %i(create)
  before_action :find_user_for_destroy, only: %i(destroy)

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def following
    @title = t ".following"
    @pagy, @users = pagy @user.following, items: Settings.pagy.items_per_page
    render "/users/show_follow"
  end

  def followers
    @title = t ".followers"
    @pagy, @users = pagy @user.followers, items: Settings.pagy.items_per_page
    render "/users/show_follow"
  end

  private

  def find_user_for_create
    @user = User.find_by id: params[:followed_id]
    return if @user

    flash[:danger] = t "invalid_user"
    redirect_to root_url
  end

  def find_user_for_destroy
    @user = Relationship.find_by(id: params[:id]).followed
    return if @user

    flash[:danger] = t "invalid_user"
    redirect_to root_url
  end
end
