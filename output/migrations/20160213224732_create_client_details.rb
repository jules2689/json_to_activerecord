class CreateClientDetails < ActiveRecord::Migration
  create_table :client_details do |t|
    t.string :browser_ip
    t.text :browser_width
    t.text :accept_language
    t.text :browser_height
    t.text :session_hash
    t.text :user_agent
    t.references :orders, index: true
    t.timestamps  null: false
  end
end