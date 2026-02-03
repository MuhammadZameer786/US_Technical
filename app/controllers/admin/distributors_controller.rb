module Admin
  class DistributorsController < ApplicationController
    before_action :require_admin
    before_action :set_distributor, only: [ :show, :edit, :update, :destroy ]

    def index
      @distributors = Distributor.all.order(:name)
    end

def show
  @distributor = Distributor.find(params[:id])
  # Fetch the SKUs directly from the distributor and eager load products
  @skus = @distributor.skus.includes(:product)
end

    def new
      @distributor = Distributor.new
    end

    def create
      @distributor = Distributor.new(distributor_params)

      if @distributor.save
        flash[:notice] = "Distributor created successfully."
        redirect_to admin_distributor_path(@distributor)
      else
        flash.now[:alert] = "Failed to create distributor."
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @distributor.update(distributor_params)
        flash[:notice] = "Distributor updated successfully."
        redirect_to admin_distributor_path(@distributor)
      else
        flash.now[:alert] = "Failed to update distributor."
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @distributor.destroy
      flash[:notice] = "Distributor deleted successfully."
      redirect_to admin_distributors_path
    end

    private

    def set_distributor
      @distributor = Distributor.find(params[:id])
    end

    def distributor_params
      params.require(:distributor).permit(:name, :currency)
    end
  end
end
