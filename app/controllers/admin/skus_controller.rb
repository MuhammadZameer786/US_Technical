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
        redirect_to admin_product_path(@product)
      else
        flash.now[:alert] = "Failed to update SKU."
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @sku.destroy
      flash[:notice] = "SKU deleted successfully."
      redirect_to admin_product_path(@product)
    end



def set_sku
  @sku = Sku.find(params[:id])
end

def set_product
   # Use product_id because the SKU's own ID is in params[:id]
   @product = Product.find(params[:product_id])
end
    def sku_params
      params.require(:sku).permit(:name, :sku_code, :price)
    end
  end
end
