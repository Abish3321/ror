class HomeController < ApplicationController

  layout 'home_layout'
  protect_from_forgery with: :exception

  helper_method :current_user

  def index
    @user = current_user
  end

  def enroll
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:notice] = 'You have successfully enrolled.'
    else
      flash[:alert] = 'Failed to enroll.'
    end
    redirect_to root_path
  end

  def cancel_enrollment
    if session[:user_id].present?
      user = User.find_by(id: session[:user_id])
      user.destroy if user.present?
      session.delete(:user_id)
      flash[:notice] = 'Your enrollment has been cancelled.'
    else
      flash[:alert] = 'No user currently enrolled.'
    end
    redirect_to root_path
  end

  def test_index
    @user = current_user
    question_ids = Question.pluck(:id).sample(10) # Get 10 random question IDs
    @questions = Question.includes(:answers).where(id: question_ids) # Fetch questions with their options
    @remaining_time = 60 # Initial remaining time in seconds
  end


  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out successfully.'
  end

  def test_instructions
    @user = current_user
    # Show instructions for the test
  end

  def submit_quiz
    user = current_user
    score = calculate_score(params[:answers])
    test = Test.create(user_id: user.id, score: score)
    if test.save
      redirect_to test_score_path(score: score)
    else
      flash[:alert] = 'Failed to save the test score.'
      redirect_to test_index_path
    end
  end

  def test_score
    @user = current_user
    @test = Test.find_by(user_id: @user.id)
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :contact_number)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def calculate_score(answers)
    correct_answers_count = 0
    if answers.present? && answers.is_a?(Hash)
      answers.each do |question_id, answer_id|
        question = Question.find_by(id: question_id)
        selected_answer = question.answers.find_by(id: answer_id)

        puts "Question ID: #{question_id}, Answer ID: #{answer_id}, Selected Answer: #{selected_answer.inspect}"

        if selected_answer && selected_answer.correct?
          correct_answers_count += 1
        end
      end
    end
    puts "Correct Answers Count: #{correct_answers_count}"
    correct_answers_count
  end
end
