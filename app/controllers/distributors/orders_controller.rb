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
  @order = Order.new
  # Eager load products to keep the page fast
  @available_skus = current_user.distributor.skus.includes(:product)
    end

def create
      @distributor = current_user.distributor
      @order = @distributor.orders.build(order_params)
      @order.user = current_user

      # We wrap this in a transaction for data integrity
      ActiveRecord::Base.transaction do
        if @order.save
          process_order_items

          # Final check: Did we actually add any items?
          if @order.order_items.empty?
            @order.errors.add(:base, "You must select at least one product.")
            raise ActiveRecord::Rollback # Cancel the save
          else
            @order.calculate_total_amount! # Method to update the grand total
            flash[:notice] = "Order ##{@order.order_number} placed successfully."
            redirect_to distributors_order_path(@order) and return
          end
        end
      end

      # If we reach here, something failed
      @available_skus = @distributor.skus.includes(:product)
      flash.now[:alert] = "Failed to place order. Please check your quantities."
      render :new, status: :unprocessable_entity
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




def process_order_items
      # Iterate through the items hash from your form: order[items][sku_id][quantity]
      params[:order][:items].each do |sku_id, item_data|
        quantity = item_data[:quantity].to_i

        if quantity > 0
          sku = Sku.find(sku_id)
          @order.order_items.create!(
            sku: sku,
            quantity: quantity, # Number of pallets
            unit_price: sku.price,
            total_price: (quantity * OrderItem::UNITS_PER_PALLET * sku.price) # 4800 units per pallet
          )
        end
      end
end
  end
end
