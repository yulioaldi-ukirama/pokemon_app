class Pokemon < ApplicationRecord
  # Validations

  # Relations
  has_and_belongs_to_many :moves
end
