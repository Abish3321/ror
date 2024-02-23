class Admin::AdminController < ApplicationController
  layout 'admin_dashboard'
  before_action :require_admin_login, except: [:login, :authenticate]
  skip_before_action :require_admin_login, only: [:login, :authenticate]


  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id]) if session[:admin_id]
  end


  def login
    # Display login form
  end

  def authenticate
    admin = Admin.find_by(username: params[:username])
    if admin && admin.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_dashboard_path, notice: 'Logged in successfully.'
    else
      flash.now[:alert] = 'Invalid username or password.'
      render :login
    end
  end

  def logout
    session[:admin_id] = nil
    redirect_to admin_login_path, notice: 'Logged out successfully'
  end

  def dashboard
    # Display admin dashboard
  end

  def user_rank
    @users_rank = User.includes(:tests).order('tests.score DESC')
  end

  private

  def require_admin_login
    redirect_to admin_login_path unless current_admin
  end
end
