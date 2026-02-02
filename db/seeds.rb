# This file should contain all the record creation needed to seed the database with its default values.

puts "Cleaning existing data..."
OrderItem.destroy_all
Order.destroy_all
DistributorSku.destroy_all
Sku.destroy_all
Product.destroy_all
User.destroy_all
Distributor.destroy_all

puts "Creating Admin User..."
admin = User.create!(
  email: 'admin@unionswiss.com',
  password: 'admin123',
  password_confirmation: 'admin123',
  user_type: 'admin'
)
puts "Admin created - Email: admin@unionswiss.com, Password: admin123"

puts "\nCreating Products and SKUs..."

# Product 1: Bio-Oil Skincare Oil
bio_oil = Product.create!(
  name: 'Bio-Oil Skincare Oil',
  description: 'Specialist skincare product that helps improve the appearance of scars, stretch marks and uneven skin tone.'
)

bio_oil_60ml = bio_oil.skus.create!(
  name: '60ml Bottle',
  sku_code: 'BIO-OIL-60ML'
)

bio_oil_125ml = bio_oil.skus.create!(
  name: '125ml Bottle',
  sku_code: 'BIO-OIL-125ML'
)

bio_oil_200ml = bio_oil.skus.create!(
  name: '200ml Bottle',
  sku_code: 'BIO-OIL-200ML'
)

# Product 2: Bio-Oil Dry Skin Gel
dry_skin = Product.create!(
  name: 'Bio-Oil Dry Skin Gel',
  description: 'Clinically proven to moisturize dry skin and provide long-lasting hydration.'
)

dry_skin_50ml = dry_skin.skus.create!(
  name: '50ml Tube',
  sku_code: 'BIO-DRY-50ML'
)

dry_skin_100ml = dry_skin.skus.create!(
  name: '100ml Tube',
  sku_code: 'BIO-DRY-100ML'
)

# Product 3: Bio-Oil Body Lotion
body_lotion = Product.create!(
  name: 'Bio-Oil Body Lotion',
  description: 'Daily moisturizing lotion with Bio-Oil\'s PurCellin Oil technology.'
)

body_lotion_175ml = body_lotion.skus.create!(
  name: '175ml Bottle',
  sku_code: 'BIO-LOTION-175ML'
)

body_lotion_250ml = body_lotion.skus.create!(
  name: '250ml Bottle',
  sku_code: 'BIO-LOTION-250ML'
)

puts "Created #{Product.count} products with #{Sku.count} SKUs"

puts "\nCreating Distributors..."

# Distributor 1: Cape Beauty Supplies
cape_beauty = Distributor.create!(name: 'Cape Beauty Supplies')

cape_user = User.create!(
  email: 'orders@capebeauty.co.za',
  password: 'cape123',
  password_confirmation: 'cape123',
  user_type: 'distributor',
  distributor: cape_beauty
)

# Assign SKUs to Cape Beauty with pricing
cape_beauty.distributor_skus.create!(sku: bio_oil_60ml, price: 89.99)
cape_beauty.distributor_skus.create!(sku: bio_oil_125ml, price: 149.99)
cape_beauty.distributor_skus.create!(sku: bio_oil_200ml, price: 219.99)
cape_beauty.distributor_skus.create!(sku: dry_skin_50ml, price: 79.99)
cape_beauty.distributor_skus.create!(sku: body_lotion_175ml, price: 119.99)

puts "Cape Beauty Supplies - Email: orders@capebeauty.co.za, Password: cape123"
puts "  Assigned #{cape_beauty.distributor_skus.count} SKUs"

# Distributor 2: Wellness Distribution SA
wellness = Distributor.create!(name: 'Wellness Distribution SA')

wellness_user = User.create!(
  email: 'purchasing@wellnessza.com',
  password: 'wellness123',
  password_confirmation: 'wellness123',
  user_type: 'distributor',
  distributor: wellness
)

# Assign different SKUs to Wellness with different pricing
wellness.distributor_skus.create!(sku: bio_oil_125ml, price: 145.00)
wellness.distributor_skus.create!(sku: bio_oil_200ml, price: 215.00)
wellness.distributor_skus.create!(sku: dry_skin_50ml, price: 75.00)
wellness.distributor_skus.create!(sku: dry_skin_100ml, price: 135.00)
wellness.distributor_skus.create!(sku: body_lotion_250ml, price: 159.99)

puts "Wellness Distribution SA - Email: purchasing@wellnessza.com, Password: wellness123"
puts "  Assigned #{wellness.distributor_skus.count} SKUs"

puts "\n" + "="*60
puts "SEED DATA CREATED SUCCESSFULLY!"
puts "="*60
puts "\nLogin Credentials:"
puts "\nADMIN:"
puts "  Email: admin@unionswiss.com"
puts "  Password: admin123"
puts "\nDISTRIBUTOR 1 (Cape Beauty Supplies):"
puts "  Email: orders@capebeauty.co.za"
puts "  Password: cape123"
puts "\nDISTRIBUTOR 2 (Wellness Distribution SA):"
puts "  Email: purchasing@wellnessza.com"
puts "  Password: wellness123"
puts "="*60