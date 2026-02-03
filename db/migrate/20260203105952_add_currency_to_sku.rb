class AddCurrencyToSku < ActiveRecord::Migration[8.1]
  def change
    add_column :skus, :currency, :string, null: false
  end
end
