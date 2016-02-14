class CreateTransactions < ActiveRecord::Migration
  create_table :transactions do |t|
    t.boolean :test
    t.integer :parent_id, index: true
    t.integer :order_id, index: true
    t.integer :location_id, index: true
    t.integer :transactions_id
    t.integer :user_id, index: true
    t.integer :device_id, index: true
    t.string :transactions_created_at
    t.string :authorization
    t.string :currency
    t.string :gateway
    t.string :source_name
    t.string :status
    t.string :kind
    t.string :amount
    t.text :message
    t.text :error_code
    t.references :refunds, index: true
    t.timestamps  null: false
  end
end