class CreateReceipts < ActiveRecord::Migration
  create_table :receipts do |t|
    t.references :transactions, index: true
    t.timestamps  null: false
  end
end