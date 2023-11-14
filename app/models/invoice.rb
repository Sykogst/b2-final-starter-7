class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  # Check if this is even required
  # has_many :bulk_discounts, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end

  def discount_revenue
    discounted = InvoiceItem.joins(merchant: :bulk_discounts)
                            .where("invoice_items.invoice_id = ?", self.id)
                            .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
                            .group("invoice_items.id")
                            .select("invoice_items.*, (1 - MAX(bulk_discounts.percentage) / 100.0) * invoice_items.quantity * invoice_items.unit_price AS item_revenue")
        
    discounted_total = discounted.sum(&:item_revenue) # Couldnt use two aggregates, so a little Ruby here, pluck(:item_revenue) did not work

    non_discounted_total = InvoiceItem.where("invoice_items.invoice_id = ?", self.id)
                                      .where.not(id: discounted.pluck(:id))
                                      .sum("invoice_items.quantity * invoice_items.unit_price")

    discount_revenue = discounted_total + non_discounted_total
  end

end
