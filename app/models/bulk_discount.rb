class BulkDiscount < ApplicationRecord
  validates_presence_of :percentage
  validates_presence_of :quantity_threshold
  belongs_to :merchant
  has_many :invoice_items, through: :merchant
end