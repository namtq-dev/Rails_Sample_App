class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    @micropost.images.attach(params[:micropost][:images])
    check_micropost_save
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t ".micropost_deleted"
    else
      flash[:danger] = t ".delete_failed"
    end
    redirect_to request.referer || root_url
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, image: [])
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    return if @micropost

    flash[:danger] = t ".invalid_micropost"
    redirect_to request.referer || root_url
  end

  def check_micropost_save
    if @micropost.save
      flash[:success] = t ".save_success"
      redirect_to root_url
    else
      @pagy, @feed_items = pagy(current_user.feed,
                                items: Settings.pagy.items_per_page)
      render "static_pages/home"
    end
  end
end
