class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :create]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show

  end

  def new

  end

  def create
    BulkDiscount.create!(bulk_discount_params)
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  def bulk_discount_params
    params.permit(:percentage, :quantity_threshold, :merchant_id)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end