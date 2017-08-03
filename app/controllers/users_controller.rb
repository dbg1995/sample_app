class UsersController < ApplicationController
  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:danger] = t "controller.user.error"
      redirect_to root_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params # Not the final implementation!
    if @user.save
      log_in @user
      remember @user
      # display a temporary messsage on the first page after at the moment
      flash[:success] = t "controller.user.welcome"
      redirect_to @user # user_path(@user)
    else
      render :new # haven't a view for create action, so must render new view
    end
  end

  private

  def user_params
    # reuire params hash to have a :user attribute, and to permit name, email,
    # password, and password confirmation attributes (but no others)
    # :user attribute does not allow miss by user_params,
    # name or email can miss in :user as part of params but not allow by
    # User model validations.If abundant the attribute of :user is alow
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
