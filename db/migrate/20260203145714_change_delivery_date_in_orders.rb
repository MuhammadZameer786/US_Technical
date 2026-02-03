class ChangeDeliveryDateInOrders < ActiveRecord::Migration[8.1]
  def change
    change_column_null :orders, :delivery_date, false
  end
end
