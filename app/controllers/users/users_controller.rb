class Users::UsersController < ApplicationController
  before_action :authenticate_user!
  def home; end

  def show; end
end
