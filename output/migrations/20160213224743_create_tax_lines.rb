class CreateTaxLines < ActiveRecord::Migration
  create_table :tax_lines do |t|
    t.float :rate
    t.string :price
    t.string :title
    t.references :orders, index: true
    t.timestamps  null: false
  end
end