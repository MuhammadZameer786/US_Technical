class CreateSkus < ActiveRecord::Migration[7.1]
  def change
    create_table :skus do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name, null: false
      t.string :sku_code, null: false

      t.timestamps
    end

    add_index :skus, :sku_code, unique: true
  end
end
