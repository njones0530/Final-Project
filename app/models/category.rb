class Category < ApplicationRecord
  has_many :workouts, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end

