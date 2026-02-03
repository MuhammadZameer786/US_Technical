# app/controllers/admin/distributors_controller.rb
module Admin
  class DistributorsController < ApplicationController
    before_action :require_admin
    before_action :set_distributor, only: [ :show, :edit, :update, :destroy ]

    # List all distributors
    def index
      @distributors = Distributor.all.order(:name)
    end

    # Show specific distributor details and their SKUs
    def show
      # @distributor is set by set_distributor
      @skus = @distributor.skus.includes(:product)
    end

    def new
      @distributor = Distributor.new
    end

    def create
      @distributor = Distributor.new(distributor_params)

      if @distributor.save
        flash[:notice] = "Distributor created successfully."
        # Redirects back to the list of distributors
        redirect_to admin_distributors_path
      else
        flash.now[:alert] = "Failed to create distributor. Please check the errors below."
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @distributor.update(distributor_params)
        flash[:notice] = "Distributor updated successfully."
        # Redirects back to the list after editing
        redirect_to admin_distributors_path
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
      # Whitelisting name and currency for the database
      params.require(:distributor).permit(:name, :currency)
    end
  end
end
