class CreateDefaultAddresses < ActiveRecord::Migration[5.0]
  create_table :default_addresses do |t|
    t.boolean :default
    t.integer :default_addresses_id
    t.string :country
    t.string :address2
    t.string :city
    t.string :phone
    t.string :zip
    t.string :province_code
    t.string :address1
    t.string :country_name
    t.string :province
    t.string :country_code
    t.string :name
    t.text :last_name
    t.text :first_name
    t.text :company
    t.references :customers, index: true
    t.timestamps  null: false
  end
end