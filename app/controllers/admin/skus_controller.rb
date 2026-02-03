module Admin
  class SkusController < ApplicationController
    before_action :require_admin
    before_action :set_sku, only: [ :edit, :update, :destroy ]
    before_action :set_product

def new
  @product = Product.find(params[:product_id])
  @sku = @product.skus.build

  # If a distributor_id is in the URL, pre-assign it to the SKU
  if params[:distributor_id]
    @sku.distributor_id = params[:distributor_id]
  end
end

def create
  # Extract product_id from the form if @product isn't set via URL
  p_id = params[:product_id] || sku_params[:product_id]
  @product = Product.find_by(id: p_id)

  if @product
    @sku = @product.skus.build(sku_params)
    if @sku.save
      flash[:notice] = "SKU created successfully."
      redirect_to admin_product_path(@product)
    else
      render :new, status: :unprocessable_entity
    end
  else
    # Handle the case where someone tries to save without a product selected
    @sku = Sku.new(sku_params)
    @sku.errors.add(:product_id, "must be selected")
    render :new, status: :unprocessable_entity
  end
end

    def edit
  @sku = Sku.find(params[:id])
  # You might also want to set @product for the breadcrumbs or headers
  @product = @sku.product
    end

def update
  if @sku.update(sku_params)
    flash[:notice] = "SKU updated successfully."

    # Check if we came from the distributor path
    if params[:distributor_id]
      redirect_to admin_distributor_path(params[:distributor_id])
    else
      redirect_to admin_product_path(@product)
    end
  else
    render :edit, status: :unprocessable_entity
  end
end


    def destroy
      @sku.destroy
      flash[:notice] = "SKU deleted successfully."
      redirect_to admin_product_path(@product)
    end



def set_sku
  if params[:distributor_id]
    # In your route /admin/distributors/9/skus/7/edit:
    # params[:distributor_id] is 9
    # params[:id] is 7 (the product_id)
    @sku = Sku.find_by!(distributor_id: params[:distributor_id], product_id: params[:id])
  else
    # Standard fallback for /admin/products/7/skus/ID
    @sku = Sku.find(params[:id])
  end
end

def set_product
      if params[:product_id]
        @product = Product.find(params[:product_id])
      elsif params[:id] && !params[:distributor_id]
        # If the ID in the URL is the Product ID (nested route)
        @product = Product.find(params[:id])
      elsif @sku
        # If we are editing, get it from the SKU
        @product = @sku.product
      end
  # If none of the above, @product stays nil (which we handle in the view)
end
    def sku_params
params.require(:sku).permit(:name, :sku_code, :price, :distributor_id, :currency, :product_id)  end
  end
end
