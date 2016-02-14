class CreateDiscountCodes < ActiveRecord::Migration
  create_table :discount_codes do |t|
    t.string :code
    t.string :amount
    t.string :discount_codes_type
    t.references :orders, index: true
    t.timestamps  null: false
  end
end