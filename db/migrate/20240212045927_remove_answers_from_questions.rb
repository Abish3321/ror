class RemoveAnswersFromQuestions < ActiveRecord::Migration[7.1]
  def change
    remove_column :questions, :answers, :text
    remove_column :questions, :correct_answer, :string
  end
end
