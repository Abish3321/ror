  class Admin::QuestionsController < ApplicationController
    layout 'admin_dashboard'
    before_action :require_admin_login

    def index
      @questions = Question.all
    end

    def new
      @question = Question.new
    end

    def edit
      @question = Question.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Question not found."
      redirect_to admin_questions_path
    end

    def update
      set_question
      if @question.update(question_params)
        redirect_to admin_questions_path, notice: 'Question was successfully updated.'
      else
        render :edit
      end
    end

    def create
      @question = Question.new(question_params)
      @question.answers = params[:question][:answers].split(",").map(&:strip) if params[:question][:answers].present?

      if @question.save
        redirect_to admin_questions_path, notice: 'Question was successfully created.'
      else
        render :new
      end
    end

    def delete
      @question.destroy
      redirect_to admin_questions_path, notice: 'Question was successfully deleted.'
    end

    private

    def set_question
      @question = Question.find(params[:id])
    end

    def require_admin_login
      redirect_to admin_login_path unless current_admin
    end

    def question_params
      params.require(:question).permit(:text, :correct_answer, :max_time_allowed)
    end
  end
