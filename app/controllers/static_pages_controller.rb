# StaticPagesController class
class StaticPagesController < ApplicationController
  def home
    return unless logged_in?
    # create a new @micropost empty to pass into form_for
    @micropost = current_user.microposts.build
    @feed_items = current_user.feed.paginate page: params[:page]
  end

  def help; end

  def about; end

  def contact; end
end
