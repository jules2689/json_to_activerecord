class CreateTrackingNumbers < ActiveRecord::Migration
  create_table :tracking_numbers do |t|
    t.text :tracking_number
    t.references :fulfillments, index: true
    t.timestamps  null: false
  end
end