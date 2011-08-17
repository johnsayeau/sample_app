class UsersController < ApplicationController
  def new
    @title = "Sign up now!"
  end

  def show
    @user = User.find(params[:id])
  end

end
