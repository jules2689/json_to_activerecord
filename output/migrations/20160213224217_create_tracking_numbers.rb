class CreateTrackingNumbers < ActiveRecord::Migration[5.0]
  create_table :tracking_numbers do |t|
    t.text :tracking_number
    t.references :fulfillments, index: true
    t.timestamps  null: false
  end
end