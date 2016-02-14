class CreateTrackingUrls < ActiveRecord::Migration
  create_table :tracking_urls do |t|
    t.text :tracking_url
    t.references :fulfillments, index: true
    t.timestamps  null: false
  end
end