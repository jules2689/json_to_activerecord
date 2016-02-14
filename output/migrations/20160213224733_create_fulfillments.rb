class CreateFulfillments < ActiveRecord::Migration
  create_table :fulfillments do |t|
    t.integer :fulfillments_id
    t.integer :order_id, index: true
    t.string :status
    t.string :fulfillments_created_at
    t.string :service
    t.string :tracking_number
    t.string :tracking_url
    t.string :fulfillments_updated_at
    t.text :tracking_company
    t.references :orders, index: true
    t.timestamps  null: false
  end
end