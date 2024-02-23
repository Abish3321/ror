
class Admin::UsersController < ApplicationController
  layout "admin_dashboard"
  before_action :require_admin_login

  def index
    @users = User.all
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.tests.destroy_all # Delete associated tests
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: 'User was successfully deleted.' }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@user) }
    end
  end

  private

  def require_admin_login
    redirect_to admin_login_path unless current_admin
  end
end
