module Admin
  class SkusController < ApplicationController
    before_action :require_admin
    before_action :set_product
    before_action :set_sku, only: [ :edit, :update, :destroy ]

    def new
      @sku = @product.skus.build
    end

    def create
      @sku = @product.skus.build(sku_params)

      if @sku.save
        flash[:notice] = "SKU created successfully."
        redirect_to admin_product_path(@product)
      else
        flash.now[:alert] = "Failed to create SKU."
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
  # Ensure @product is set so the redirect_to admin_product_path(@product) works
  @product = @sku ? @sku.product : Product.find(params[:product_id] || params[:id])
end
    def sku_params
params.require(:sku).permit(:name, :sku_code, :price, :distributor_id, :currency)    end
  end
end
