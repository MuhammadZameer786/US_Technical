module Admin
  class SkusController < ApplicationController
    before_action :require_admin
    before_action :set_sku, only: [ :edit, :update, :destroy ]
    before_action :set_product

def new
  @product = Product.find_by(id: params[:product_id])
  @sku = @product ? @product.skus.build : Sku.new

  if params[:distributor_id]
    @distributor = Distributor.find(params[:distributor_id])
    @sku.distributor_id = @distributor.id
    @sku.currency = @distributor.currency
  end
end

def create
  # Extract product_id from the form if @product isn't set via URL
  p_id = params[:product_id] || sku_params[:product_id]
  @product = Product.find_by(id: p_id)

  if @product
    @sku = @product.skus.build(sku_params)
    @sku.name = @product.name
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

    # Use the @distributor set in set_sku or the param
    if params[:distributor_id] || @distributor
      redirect_to admin_distributor_path(params[:distributor_id] || @distributor.id)
    else
      redirect_to admin_product_path(@sku.product_id)
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
  # 1. Always find the SKU by its primary ID first.
  # This ID (22 in your example) is unique across the whole table.
  @sku = Sku.find(params[:id])

  # 2. If you are in a distributor context, you can set @distributor
  # for your breadcrumbs or headers, but don't use it for the SKU lookup.
  if params[:distributor_id]
    @distributor = Distributor.find(params[:distributor_id])
  end
rescue ActiveRecord::RecordNotFound
  redirect_to admin_distributors_path, alert: "The SKU you are looking for does not exist."
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
