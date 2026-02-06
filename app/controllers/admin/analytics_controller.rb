module Admin
  class AnalyticsController < ApplicationController
    before_action :require_admin

    def index
      # Date range - default to last 30 days
      @start_date = params[:start_date]&.to_date || 30.days.ago.to_date
      @end_date = params[:end_date]&.to_date || Date.today

      # Total Revenue
      @total_revenue = Order.where(created_at: @start_date..@end_date)
                           .sum(:total_amount)

      # Orders by Status (if you have status)
      if Order.respond_to?(:statuses)
        @orders_by_status = Order.where(created_at: @start_date..@end_date)
                                 .group(:status)
                                 .count
      end

      # Orders Over Time (grouped by day)
      @orders_by_day = Order.where(created_at: @start_date..@end_date)
                           .group_by_day(:created_at)
                           .count

      # Revenue Over Time
      @revenue_by_day = Order.where(created_at: @start_date..@end_date)
                            .group_by_day(:created_at)
                            .sum(:total_amount)

      # Top Distributors by Order Count
      @top_distributors_by_orders = Distributor.joins(:orders)
                                               .where(orders: { created_at: @start_date..@end_date })
                                               .select("distributors.*, COUNT(orders.id) as order_count")
                                               .group("distributors.id")
                                               .order("order_count DESC")
                                               .limit(5)

      # Top Distributors by Revenue
      @top_distributors_by_revenue = Distributor.joins(:orders)
                                                .where(orders: { created_at: @start_date..@end_date })
                                                .select("distributors.*, SUM(orders.total_amount) as total_revenue")
                                                .group("distributors.id")
                                                .order("total_revenue DESC")
                                                .limit(5)

      # Top Products (most ordered)
      @top_products = Product.joins(skus: { order_items: :order })
                            .where(orders: { created_at: @start_date..@end_date })
                            .select("products.*, SUM(order_items.quantity) as total_pallets, SUM(order_items.total_price) as revenue")
                            .group("products.id")
                            .order("total_pallets DESC")
                            .limit(5)

      # Average Order Value
      @average_order_value = Order.where(created_at: @start_date..@end_date)
                                  .average(:total_amount) || 0

      # Total Orders in Period
      @total_orders = Order.where(created_at: @start_date..@end_date).count

      # Total Units Sold
      @total_units = OrderItem.joins(:order)
                             .where(orders: { created_at: @start_date..@end_date })
                             .sum("order_items.quantity * 4800") # 4800 units per pallet
    end
  end
end
