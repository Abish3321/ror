class CreateFeedbacks < ActiveRecord::Migration[7.1]
  def change
    create_table :feedbacks do |t|
      t.string :subject
      t.text :feedback
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
