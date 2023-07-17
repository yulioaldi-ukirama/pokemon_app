class Pokemon < ApplicationRecord
  # Validations

  # Relations
  has_and_belongs_to_many :moves
  has_and_belongs_to_many :types
  has_and_belongs_to_many :battles
end
