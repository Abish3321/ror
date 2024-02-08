class Question < ApplicationRecord
  serialize :answers, Array, coder: JSON

end
