class CreateRefunds < ActiveRecord::Migration[5.0]
  create_table :refunds do |t|
    t.boolean :restock
    t.integer :order_id, index: true
    t.integer :refunds_id
    t.integer :user_id, index: true
    t.string :refunds_created_at
    t.string :note
    t.references :orders, index: true
    t.timestamps  null: false
  end
end