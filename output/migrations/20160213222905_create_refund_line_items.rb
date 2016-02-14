class CreateRefundLineItems < ActiveRecord::Migration[5.0]
  create_table :refund_line_items do |t|
    t.integer :refund_line_items_id
    t.integer :line_item_id, index: true
    t.integer :quantity
    t.references :refunds, index: true
    t.timestamps  null: false
  end
end