class Pokemon < ApplicationRecord
  # Validations
  validates :power, presence: true, numericality: { greater_than: 0, less_than: 100 }

  # Relations
  has_and_belongs_to_many :moves
end
