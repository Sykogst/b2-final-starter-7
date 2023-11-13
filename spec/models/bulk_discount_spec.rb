require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe "validations" do
    it { should validate_presence_of :percentage}
    it { should validate_presence_of :quantity_threshold }
    it { should validate_numericality_of(:percentage).is_greater_than_or_equal_to(0).only_integer }
    it { should validate_numericality_of(:quantity_threshold).is_greater_than_or_equal_to(0).only_integer }
  end
  describe "relationships" do
    it { should belong_to :merchant }
    it { should have_many(:invoice_items).through(:merchant) }
  end
end