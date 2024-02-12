class Question < ApplicationRecord
  serialize :answers, Array, coder: JSON
  has_many :answers, dependent: :destroy

end
