class Pokemon < ApplicationRecord
  validates :power, presence: true, numericality: { greater_than: 0, less_than: 100 }
end
