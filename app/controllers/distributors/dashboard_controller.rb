module Distributors
  class DashboardController < ApplicationController
    before_action :require_distributor

    def index
      @distributor = current_user.distributor
      @available_skus = @distributor.skus
      @recent_orders = @distributor.orders.order(created_at: :desc).limit(10)
      if @available_skus.empty?
        flash.now[:alert] = "No products are currently available for your account. Please contact the administrator."
      end
    end
  end
end
