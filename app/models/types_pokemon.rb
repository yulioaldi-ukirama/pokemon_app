class TypesPokemon < ApplicationRecord
  # Validations
  # validates :validate_selected_types

  # Relations
  belongs_to :type
  belongs_to :pokemon

  # private

  # def validate_selected_types
  #   unless type_ids.length >= 1 && type_ids.length <= 2
  #     errors.add(:type_ids, "must select at least 1 and at most 2 types")
  #   end
  # end
end
