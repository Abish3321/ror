class Admin::QuestionsController < ApplicationController
  layout 'admin_dashboard'
  before_action :require_admin_login
  before_action :set_question, only: [:edit, :update, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def update
    if @question.update(question_params)
      update_answers
      redirect_to admin_questions_path, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end


  def destroy
    @question.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@question) }
      format.html { redirect_to admin_questions_path, notice: 'Question was successfully deleted.' }
    end
  end


  def create
    @question = Question.new(question_params)
    if @question.save
      create_answers
      redirect_to admin_questions_path, notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  private

  def update_answers
    correct_option_text = params[:question][:correct_answer]

    # Define option-answer associations based on position in the answers list
    option_answer_map = {
      option_a: @question.answers.first,
      option_b: @question.answers.second,
      option_c: @question.answers.third,
      option_d: @question.answers.fourth
    }

    # Iterate over options and update correct status
    option_answer_map.each do |option, answer|
      if option.to_s == correct_option_text
        answer.update(correct: true)
      else
        answer.update(correct: false)
      end
    end
  end


  def set_question
    @question = Question.find(params[:id])
  end

  def require_admin_login
    redirect_to admin_login_path unless current_admin
  end

  def question_params
    params.require(:question).permit(:text, :correct_answer, :option_a, :option_b, :option_c, :option_d, answers_attributes: [:id, :text])
  end

  def create_answers
    correct_option = params[:question][:correct_answer]
    option_texts = [:option_a, :option_b, :option_c, :option_d]
    option_texts.each do |option_text|
      Answer.create(
        question: @question,
        text: params[:question][option_text],
        correct: (option_text.to_s == correct_option)
      )
    end
  end

  helper_method :correct_answer_for_question

  def correct_answer_for_question(question)
    correct_option = Answer.find_by(question_id: question.id, correct: true)
    correct_option.text if correct_option.present?
  end
end
