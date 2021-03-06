class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %I[create destroy]
  before_action :correct_user, only: :destroy
  def create # current_user of sessions_helper included application_controller
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = t "controller.micropost.create.success"
      redirect_to root_url
    else
      @feed_items = []
      render "static_pages/home"
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "controller.micropost.destroy.success"
      redirect_back fallback_location: root_url
      # redirect back to the page issuing the delete request in home or profile,if
      # haven't redirect to root_url
    else
      flash[:danger] = t "controller.micropost.destroy.danger"
      redirect_to root_url
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    # microposts's id is unique so with a micropost belong a user, so find
    # micropost on current_user will ensure correct user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url if @micropost.blank?
  end
end
