class CreateShippingLines < ActiveRecord::Migration
  create_table :shipping_lines do |t|
    t.string :code
    t.string :price
    t.string :source
    t.string :title
    t.references :orders, index: true
    t.timestamps  null: false
  end
end