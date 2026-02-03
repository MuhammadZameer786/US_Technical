module Distributors
  class OrdersController < ApplicationController
    before_action :require_distributor
    before_action :set_order, only: [ :show, :review ]

    def index
      @orders = current_user.distributor.orders.includes(:order_items).order(created_at: :desc)
    end

    def show
      @order_items = @order.order_items.includes(sku: :product)
    end

    def new
      @distributor = current_user.distributor
      @available_skus = @distributor.skus.includes(sku: :product)

      if @available_skus.empty?
        flash[:alert] = "No products are currently available. Please contact the administrator."
        redirect_to distributors_dashboard_path
      else
        @order = Order.new
      end
    end

    def create
      @distributor = current_user.distributor
      @order = @distributor.orders.build(order_params.merge(user: current_user))

      begin
        ActiveRecord::Base.transaction do
          @order.save!

          # Create order items from cart data
          cart_items = params[:order][:items] || {}
          cart_items.each do |sku_id, item_data|
            quantity = item_data[:quantity].to_i
            next if quantity <= 0

            sku = Sku.find(sku_id)
            distributor = @distributor.skus.find_by!(sku: sku)

            @order.order_items.create!(
              sku: sku,
              quantity: quantity,
              unit_price: distributor.price,
              total_price: quantity * distributor.price
            )
          end

          if @order.order_items.empty?
            raise ActiveRecord::RecordInvalid.new(@order)
          end

          @order.calculate_total
          @order.save!
        end

        flash[:notice] = "Order placed successfully!"
        redirect_to distributors_order_path(@order)
      rescue ActiveRecord::RecordInvalid => e
        @available_skus = @distributor.skus.includes(sku: :product)
        flash.now[:alert] = "Failed to create order. Please check the form and try again."
        render :new, status: :unprocessable_entity
      rescue ActiveRecord::RecordNotFound
        @available_skus = @distributor.skus.includes(sku: :product)
        flash.now[:alert] = "Invalid SKU selected. You can only order products assigned to your account."
        render :new, status: :unprocessable_entity
      end
    end

    def review
      @order_items = @order.order_items.includes(sku: :product)
    end

    private

    def set_order
      @order = current_user.distributor.orders.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:required_delivery_date)
    end
  end
end
