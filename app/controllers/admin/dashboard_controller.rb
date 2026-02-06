module Admin
  class DashboardController < ApplicationController
    before_action :require_admin
    include Pagy::Backend


    def index
      @distributors_count = Distributor.count
      @products_count = Product.count
      @orders_count = Order.count

      # Ransack search with all associations
      @q = Order.ransack(params[:q])

      # Pagy pagination with eager loading
      @pagy, @recent_orders = pagy(
        @q.result(distinct: true)
          .includes(:distributor, :user, order_items: { sku: :product })
          .order(created_at: :desc),
        items: 10
      )
    end
  end
end
