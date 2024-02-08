class HomeController < ApplicationController
  layout "home_layout"

  def index
    @user = User.new
  end

  def enroll_user
    if request.post?
      @user = User.new(user_params)
      if @user.save
        redirect_to test_landing_path(user_id: @user.id)
      else
        flash[:alert] = 'Error saving user details'
        render :enrollment_modal
      end
    else
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :email, :contact_number)
  end

end
