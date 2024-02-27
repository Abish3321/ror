class User < ApplicationRecord
  has_many :tests, dependent: :destroy
  has_many :test_answers, through: :tests, source: :answers
end
