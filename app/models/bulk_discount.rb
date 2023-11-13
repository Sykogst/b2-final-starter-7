class BulkDiscount < ApplicationRecord
  validates_presence_of :percentage
  validates_presence_of :quantity_threshold
  validates :percentage, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :quantity_threshold, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  belongs_to :merchant
  has_many :invoice_items, through: :merchant
end