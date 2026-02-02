class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :order_number, null: false
      t.references :distributor, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.date :required_delivery_date, null: false
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
  end
end
