module Admin
  class DashboardController < ApplicationController
    before_action :require_admin

    def index
      @distributors_count = Distributor.count
      @products_count = Product.count
      @orders_count = Order.count
      @recent_orders = Order.includes(:distributor, :user).order(created_at: :desc).limit(10)
    end
  end
end
