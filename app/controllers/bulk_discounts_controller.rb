class BulkDiscountsController < ApplicationController
  before_action :find_merchant, only: [:index, :new, :create, :destroy]
  before_action :find_bulk_discount, only: [:destroy]

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
  end

  def new
  end

  def create
    new_discount = BulkDiscount.new(bulk_discount_params)
    if new_discount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alert] = error_message(new_discount.errors)
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def destroy
    @bulk_discount.destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  private
  def bulk_discount_params
    params.permit(:percentage, :quantity_threshold, :merchant_id)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end