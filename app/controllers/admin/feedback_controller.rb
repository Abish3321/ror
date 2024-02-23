class Admin::FeedbackController < ApplicationController
  layout 'admin_dashboard'
  before_action :require_admin_login

  def index
    @feedbacks = Feedback.all
  end

  def show
    @feedback = Feedback.find(params[:id])
  end

  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy! # Use destroy! for immediate deletion
    redirect_to admin_feedbacks_path, notice: 'Feedback was successfully deleted.'
  end


  private
  def require_admin_login
    redirect_to admin_login_path unless current_admin
  end
end
