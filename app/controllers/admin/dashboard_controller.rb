module Admin
  class DashboardController < ApplicationController
    before_action :require_admin
    include Pagy::Backend


    def index
          @q = Order.ransack(params[:q])

      @distributors_count = Distributor.count
      @products_count = Product.count
      @orders_count = Order.count
    # @recent_orders = Order.includes(:distributor, :user).order(created_at: :desc).limit(10)
    @pagy, @recent_orders = pagy(@q.result.includes(:distributor, :user, order_items: :sku).order(created_at: :desc),
    limit: 10
  )
    end
  end
end
