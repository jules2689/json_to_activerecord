class CreateLineItems < ActiveRecord::Migration[5.0]
  create_table :line_items do |t|
    t.boolean :gift_card
    t.boolean :requires_shipping
    t.boolean :taxable
    t.boolean :product_exists
    t.integer :grams
    t.integer :line_items_id
    t.integer :product_id, index: true
    t.integer :variant_id, index: true
    t.integer :quantity
    t.integer :fulfillable_quantity
    t.string :sku
    t.string :price
    t.string :name
    t.string :variant_inventory_management
    t.string :fulfillment_service
    t.string :variant_title
    t.string :title
    t.text :fulfillment_status
    t.text :vendor
    t.references :orders, index: true
    t.timestamps  null: false
  end
end