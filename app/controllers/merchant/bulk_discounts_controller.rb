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
      flash[:error] = bulk_discount.errors.full_messages.to_sentence
      redirect_to new_merchant_bulk_discount_path
    end
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.update(bulk_discount_params)
    if bulk_discount.save
      flash[:success] = "#{bulk_discount.name} Updated Successfully"
      redirect_to merchant_bulk_discount_path(bulk_discount.id)
    else
      flash[:error] = bulk_discount.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy
    flash[:success] = "Discount Deleted"
    redirect_to '/merchant'
  end

  private
  def bulk_discount_params
    params.permit(:name, :description, :discount_percentage, :item_count_threshold)
  end
end
