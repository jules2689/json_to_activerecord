class CreateCustomers < ActiveRecord::Migration[5.0]
  create_table :customers do |t|
    t.boolean :accepts_marketing
    t.boolean :verified_email
    t.integer :customers_id
    t.integer :multipass_identifier, index: true
    t.integer :orders_count
    t.integer :last_order_id, index: true
    t.string :email
    t.string :state
    t.string :customers_created_at
    t.string :customers_updated_at
    t.string :last_name
    t.string :last_order_name
    t.string :first_name
    t.string :total_spent
    t.string :tags
    t.text :note
    t.references :orders, index: true
    t.timestamps  null: false
  end
end