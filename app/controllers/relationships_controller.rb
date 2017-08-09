class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    current_user.follow @user
    respond_to do |format| # respond appropriately depending on the type of request
      format.html{redirect_to @user} # format is html will it excuse
      format.js # format is js(ajax) will it excuse <action>.js.erb
    end
  end

  def destroy
    # form send a Relationship's id
    @user = Relationship.find_by(id: params[:id]).followed # followed user
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end
end
