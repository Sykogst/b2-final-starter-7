class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show

  end

  def new
    
  end

  private
  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end