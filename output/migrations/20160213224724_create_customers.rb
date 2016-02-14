class CreateCustomers < ActiveRecord::Migration
  create_table :customers do |t|
    t.boolean :accepts_marketing
    t.boolean :verified_email
    t.integer :customers_id
    t.integer :orders_count
    t.integer :last_order_id, index: true
    t.string :customers_created_at
    t.string :email
    t.string :total_spent
    t.string :first_name
    t.string :customers_updated_at
    t.string :tags
    t.string :last_order_name
    t.string :last_name
    t.string :state
    t.text :note
    t.text :multipass_identifier, index: true
    t.references :orders, index: true
    t.timestamps  null: false
  end
end