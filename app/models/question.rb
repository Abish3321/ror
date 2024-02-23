class Question < ApplicationRecord
  serialize :answers, Array, coder: JSON
  has_many :answers, dependent: :destroy
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true

  attr_accessor :option_a, :option_b, :option_c, :option_d
  enum correct_answer: { option_a: 'option_a', option_b: 'option_b', option_c: 'option_c', option_d: 'option_d' }



end
