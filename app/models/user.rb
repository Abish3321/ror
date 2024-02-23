class User < ApplicationRecord
  has_many :tests, dependent: :destroy
end
