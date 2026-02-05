# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_02_05_231352) do
  create_table "distributors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency", default: "ZAR", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["currency"], name: "index_distributors_on_currency"
  end

  create_table "order_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "order_id", null: false
    t.integer "quantity", null: false
    t.integer "sku_id", null: false
    t.decimal "total_price", precision: 10, scale: 2, null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["sku_id"], name: "index_order_items_on_sku_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "distributor_id", null: false
    t.string "order_number", null: false
    t.date "required_delivery_date", null: false
    t.integer "status"
    t.decimal "total_amount", precision: 10, scale: 2, default: "0.0"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["distributor_id"], name: "index_orders_on_distributor_id"
    t.index ["order_number"], name: "index_orders_on_order_number", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_products_on_discarded_at"
  end

  create_table "skus", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency", null: false
    t.datetime "discarded_at"
    t.integer "distributor_id", null: false
    t.string "name", null: false
    t.decimal "price"
    t.integer "product_id", null: false
    t.string "sku_code", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_skus_on_discarded_at"
    t.index ["distributor_id"], name: "index_skus_on_distributor_id"
    t.index ["product_id", "distributor_id"], name: "index_skus_on_product_id_and_distributor_id", unique: true
    t.index ["product_id"], name: "index_skus_on_product_id"
    t.index ["sku_code"], name: "index_skus_on_sku_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "distributor_id"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.string "user_type", null: false
    t.index ["distributor_id"], name: "index_users_on_distributor_id"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "skus"
  add_foreign_key "orders", "distributors"
  add_foreign_key "orders", "users"
  add_foreign_key "skus", "distributors"
  add_foreign_key "skus", "products"
  add_foreign_key "users", "distributors"
end
