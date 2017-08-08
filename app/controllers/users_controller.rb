class UsersController < ApplicationController
  before_action :load_user, only: %I[show destroy edit update]
  before_action :logged_in_user, only: %I[index edit update destroy] # an array of symbol
  before_action :correct_user, only: %I[edit update] # only edit their infor
  before_action :admin_user, only: :destroy

  def index
    # of rails. A hash argument with key :page, value is number page requested
    # return 30 users one time if enough. params[:page] is generated
    # automatically by will_paginate in view.
    @users = User.select_user_activated.paginate page: params[:page]
  end

  def show
    return if @user.activated?
    flash[:danger] = t"controller.user.error_activate"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create # post
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t"controller.user.create.info"
      redirect_to root_url
    else
      render :new # haven't a view for create action, so must render new view
    end
  end

  def edit; end

  def update # patch
    if @user.update_attributes user_params
      flash[:success] = t"controller.user.updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t"controller.user.destroy.success"
    redirect_to users_url
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

  def load_user
    @user = User.find_by id: params[:id] # request to other user
    return if @user
    flash[:danger] = t"controller.user.error_id"
    redirect_to root_path
  end
end
