class AddCurrencyToDistributors < ActiveRecord::Migration[8.1]
  def change
    add_column :distributors, :currency, :string, null: false, default: 'ZAR'

  # each country only has one distributer
  add_index :distributors, :currency
  end
end
