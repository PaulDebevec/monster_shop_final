
ActiveRecord::Schema.define(version: 20200301184235) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bulk_discounts", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.integer "discount_percentage"
    t.integer "item_count_threshold"
    t.bigint "merchant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_bulk_discounts_on_merchant_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.float "price"
    t.integer "inventory"
    t.string "image"
    t.boolean "active", default: true
    t.bigint "merchant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id"], name: "index_items_on_merchant_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "enabled", default: true
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "order_id"
    t.float "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "fulfilled", default: false
    t.index ["item_id"], name: "index_order_items_on_item_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "status", default: 0
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "rating"
    t.bigint "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_reviews_on_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.bigint "merchant_id"
    t.index ["merchant_id"], name: "index_users_on_merchant_id"
  end

  add_foreign_key "bulk_discounts", "merchants"
  add_foreign_key "items", "merchants"
  add_foreign_key "order_items", "items"
  add_foreign_key "order_items", "orders"
  add_foreign_key "orders", "users"
  add_foreign_key "reviews", "items"
  add_foreign_key "users", "merchants"
end
