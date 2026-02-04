module Admin
  class ProductsController < ApplicationController
    before_action :require_admin
    before_action :set_product, only: [ :show, :edit, :update, :destroy ]

    def index
      @products = Product.includes(:skus).active.order(:name)
    end

    def show
      @skus = @product.skus
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)

      if @product.save
        flash[:notice] = "Product created successfully."
        redirect_to admin_product_path(@product)
      else
        flash.now[:alert] = "Failed to create product."
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @product.update(product_params)
        flash[:notice] = "Product updated successfully."
        redirect_to admin_product_path(@product)
      else
        flash.now[:alert] = "Failed to update product."
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product = Product.find(params[:id])
      if @product.soft_delete
        flash[:notice] = "Product deleted successfully."
      else
        flash[:error] = "Product could not be archived."
      end

      redirect_to admin_products_path
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description)
    end
  end
end
