class CreateProperties < ActiveRecord::Migration
  create_table :properties do |t|
    t.text :property
    t.references :line_items, index: true
    t.timestamps  null: false
  end
end