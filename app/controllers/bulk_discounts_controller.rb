class BulkDiscountsController < ApplicationController
  before_action :find_merchant
  before_action :find_bulk_discount, only: [:destroy, :show, :edit, :update]

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
      flash[:notice] = 'Succesfully Added Discount!'
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alert] = error_message(new_discount.errors)
      redirect_to new_merchant_bulk_discount_path(@merchant)
    end
  end

  def destroy
    if @bulk_discount.destroy
      flash[:notice] = 'Successfully deleted discount'
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alert] = 'Failed to delete discount'
      redirect_to merchant_bulk_discounts_path(@merchant)
    end
  end

  def edit
  end

  def update
    if @bulk_discount.update(bulk_discount_params)
      flash[:notice] = 'Succesfully Updated Discount Info!'
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
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