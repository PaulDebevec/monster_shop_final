class Merchant::BulkDiscountsController < Merchant::BaseController
  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end
end
