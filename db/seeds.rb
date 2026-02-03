puts "Cleaning existing data..."
OrderItem.destroy_all
Order.destroy_all
Sku.destroy_all
Product.destroy_all
User.destroy_all
Distributor.destroy_all

puts "Creating Admin User..."
User.create!(
  email: 'admin@unionswiss.com',
  password: 'admin123',
  password_confirmation: 'admin123',
  user_type: 'admin'
)

puts "\nCreating Distributors..."
cape_beauty = Distributor.create!(name: 'Cape Beauty Supplies', currency: 'ZAR')
wellness = Distributor.create!(name: 'Wellness Distribution SA', currency: 'ZAR')

# Distributor Users
User.create!(
  email: 'orders@capebeauty.co.za',
  password: 'cape123',
  password_confirmation: 'cape123',
  user_type: 'distributor',
  distributor: cape_beauty
)

User.create!(
  email: 'purchasing@wellnessza.com',
  password: 'wellness123',
  password_confirmation: 'wellness123',
  user_type: 'distributor',
  distributor: wellness
)

puts "\nCreating Products..."
bio_oil = Product.create!(
  name: 'Bio-Oil Skincare Oil',
  description: 'Specialist skincare product that helps improve the appearance of scars.'
)

dry_skin = Product.create!(
  name: 'Bio-Oil Dry Skin Gel',
  description: 'Clinically proven to moisturize dry skin.'
)

puts "\nCreating SKUs (Product + Distributor intersection)..."

# SKUs for Cape Beauty Supplies
Sku.create!(
  product: bio_oil,
  distributor: cape_beauty,
  name: bio_oil.name, # Requirement: Name derived from product
  sku_code: 'CAP-BIO-60',
  currency: 'ZAR',
  price: 89.99
)

Sku.create!(
  product: dry_skin,
  distributor: cape_beauty,
  name: dry_skin.name,
  sku_code: 'CAP-DRY-50',
    currency: 'ZAR',
  price: 79.99
)

# SKUs for Wellness Distribution SA
# Notice Wellness has a different price and code for the same Product
Sku.create!(
  product: bio_oil,
  distributor: wellness,
  name: bio_oil.name,
  sku_code: 'WEL-BIO-60',
    currency: 'ZAR',

  price: 85.00
)

Sku.create!(
  product: dry_skin,
  distributor: wellness,
  name: dry_skin.name,
  sku_code: 'WEL-DRY-50',
    currency: 'USD',

  price: 75.00
)

puts "Created #{Product.count} products with #{Sku.count} unique Distributor SKUs."
