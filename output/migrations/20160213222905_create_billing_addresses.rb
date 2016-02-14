class CreateBillingAddresses < ActiveRecord::Migration[5.0]
  create_table :billing_addresses do |t|
    t.float :latitude
    t.float :longitude
    t.string :country
    t.string :last_name
    t.string :city
    t.string :address2
    t.string :phone
    t.string :zip
    t.string :country_code
    t.string :province_code
    t.string :province
    t.string :first_name
    t.string :name
    t.string :address1
    t.text :company
    t.references :orders, index: true
    t.timestamps  null: false
  end
end