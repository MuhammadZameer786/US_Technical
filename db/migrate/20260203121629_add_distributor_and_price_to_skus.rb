class AddDistributorAndPriceToSkus < ActiveRecord::Migration[8.1]
  def change
    add_reference :skus, :distributor, null: false, foreign_key: true
    add_column :skus, :price, :decimal
  end
end
