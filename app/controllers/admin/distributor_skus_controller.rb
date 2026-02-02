module Admin
  class DistributorSkusController < ApplicationController
    before_action :require_admin
    before_action :set_distributor
    before_action :set_distributor_sku, only: [:edit, :update, :destroy]

    def new
      @distributor_sku = @distributor.distributor_skus.build
      @available_skus = Sku.includes(:product).all
    end

    def create
      @distributor_sku = @distributor.distributor_skus.build(distributor_sku_params)

      if @distributor_sku.save
        flash[:notice] = "SKU assigned to distributor successfully."
        redirect_to admin_distributor_path(@distributor)
      else
        @available_skus = Sku.includes(:product).all
        flash.now[:alert] = "Failed to assign SKU."
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @available_skus = Sku.includes(:product).all
    end

    def update
      if @distributor_sku.update(distributor_sku_params)
        flash[:notice] = "Pricing updated successfully."
        redirect_to admin_distributor_path(@distributor)
      else
        @available_skus = Sku.includes(:product).all
        flash.now[:alert] = "Failed to update pricing."
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @distributor_sku.destroy
      flash[:notice] = "SKU removed from distributor."
      redirect_to admin_distributor_path(@distributor)
    end

    private

    def set_distributor
      @distributor = Distributor.find(params[:distributor_id])
    end

    def set_distributor_sku
      @distributor_sku = @distributor.distributor_skus.find(params[:id])
    end

    def distributor_sku_params
      params.require(:distributor_sku).permit(:sku_id, :price)
    end
  end
end
