class CreateReceipts < ActiveRecord::Migration
  create_table :receipts do |t|
    t.boolean :testcase
    t.string :authorization
    t.references :fulfillments, index: true
    t.timestamps  null: false
  end
end