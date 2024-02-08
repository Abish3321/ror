class CreateQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :questions do |t|
      t.text :text
      t.text :answers
      t.string :correct_answer
      t.integer :max_time_allowed

      t.timestamps
    end
  end
end
