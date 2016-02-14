class CreateTaxLines < ActiveRecord::Migration
  create_table :tax_lines do |t|
    t.text :tax_line
    t.references :line_items, index: true
    t.timestamps  null: false
  end
end