class AddDiscardedAtToSku < ActiveRecord::Migration[8.1]
  def change
    add_column :skus, :discarded_at, :datetime
    add_index :skus, :discarded_at
  end
end
