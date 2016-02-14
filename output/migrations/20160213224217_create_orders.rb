class CreateOrders < ActiveRecord::Migration[5.0]
  create_table :orders do |t|
    t.boolean :buyer_accepts_marketing
    t.boolean :confirmed
    t.boolean :test
    t.boolean :taxes_included
    t.datetime :closed_at
    t.datetime :cancelled_at
    t.integer :orders_id
    t.integer :device_id, index: true
    t.integer :location_id, index: true
    t.integer :number
    t.integer :total_weight
    t.integer :user_id, index: true
    t.integer :order_number
    t.integer :checkout_id, index: true
    t.string :email
    t.string :gateway
    t.string :financial_status
    t.string :source_name
    t.string :landing_site
    t.string :orders_created_at
    t.string :token
    t.string :total_line_items_price
    t.string :reference
    t.string :subtotal_price
    t.string :orders_updated_at
    t.string :currency
    t.string :landing_site_ref
    t.string :cart_token
    t.string :source
    t.string :total_price_usd
    t.string :tags
    t.string :processed_at
    t.string :source_identifier, index: true
    t.string :total_discounts
    t.string :referring_site
    t.string :total_price
    t.string :processing_method
    t.string :name
    t.string :total_tax
    t.text :fulfillment_status
    t.text :cancel_reason
    t.text :source_url
    t.text :checkout_token
    t.text :note
    t.text :browser_ip
    t.timestamps  null: false
  end
end