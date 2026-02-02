class CreateDistributorSkus < ActiveRecord::Migration[7.1]
  def change
    create_table :distributor_skus do |t|
      t.references :distributor, null: false, foreign_key: true
      t.references :sku, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :distributor_skus, [:distributor_id, :sku_id], unique: true
  end
end
