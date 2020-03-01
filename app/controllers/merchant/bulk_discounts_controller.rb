class Merchant::BulkDiscountsController < Merchant::BaseController
  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
  end

  def create
    merchant = current_user.merchant
    bulk_discount = merchant.bulk_discounts.new(bulk_discount_params)
    if bulk_discount.save
      redirect_to "/merchant/bulk_discounts/#{bulk_discount.id}"
      flash[:success] = "Bulk Discount Created"
    else
      flash[:success] = bulk_discount.errors.full_messages.to_sentence
      render :new
    end
  end

  private
  def bulk_discount_params
    params.permit(:name, :description, :discount_percentage, :item_count_threshold)
  end
end
