class CreatePaymentDetails < ActiveRecord::Migration
  create_table :payment_details do |t|
    t.string :credit_card_number
    t.string :credit_card_company
    t.text :cvv_result_code
    t.text :avs_result_code
    t.text :credit_card_bin
    t.references :orders, index: true
    t.timestamps  null: false
  end
end