# json_to_activerecord

By placing a json blob in `data.json` and then running `./parse.rb` in terminal, this script will determine and output a basic ActiveRecord format.

Features
---
 - Will try to intelligently detect the column type by the type of value in the JSON. 
  - If the value is null, it will try to determine the type from the key (*_id is int, *_at is datetime). 
  - It defaults to text otherwise.
  - If it guesses the type, it will warn you in the output.
 - Can handle nested hashes as separate tables
 - Can handle references columns as "indexed".
 - Any id column is indexed.
 - Can handle a business hours hash, something like the following will be parsed separately.
 ```
 "hours":{  
      "Tuesday":{  
         "close":"19:00",
         "open":"10:00"
      },
      "Friday":{  
         "close":"20:00",
         "open":"10:00"
      },
      "Saturday":{  
         "close":"16:00",
         "open":"10:00"
      },
      "Thursday":{  
         "close":"19:00",
         "open":"10:00"
      },
      "Wednesday":{  
         "close":"19:00",
         "open":"10:00"
      }
   }
   ```

While this may not be perfect, it is a great start and saves a lot of manual entry.
For example, by giving the parser a Shopify Order JSON object, we are given this back in the console:

```
create_table :order do |t|
  t.boolean :buyer_accepts_marketing
  t.boolean :confirmed
  t.boolean :taxes_included
  t.boolean :test
  t.datetime :cancelled_at
  t.datetime :closed_at
  t.integer :checkout_id, index: true
  t.integer :device_id, index: true
  t.integer :location_id, index: true
  t.integer :number
  t.integer :order_id
  t.integer :order_number
  t.integer :total_weight
  t.integer :user_id, index: true
  t.string :cart_token
  t.string :created_at
  t.string :currency
  t.string :email
  t.string :financial_status
  t.string :gateway
  t.string :landing_site
  t.string :landing_site_ref
  t.string :name
  t.string :processed_at
  t.string :processing_method
  t.string :reference
  t.string :referring_site
  t.string :source
  t.string :source_identifier, index: true
  t.string :source_name
  t.string :subtotal_price
  t.string :tags
  t.string :token
  t.string :total_discounts
  t.string :total_line_items_price
  t.string :total_price
  t.string :total_price_usd
  t.string :total_tax
  t.string :updated_at
  t.text :browser_ip
  t.text :cancel_reason
  t.text :checkout_token
  t.text :fulfillment_status
  t.text :note
  t.text :source_url
  t.timestamps
end

create_table :customer do |t|
  t.boolean :accepts_marketing
  t.boolean :verified_email
  t.integer :customer_id
  t.integer :last_order_id, index: true
  t.integer :multipass_identifier, index: true
  t.integer :orders_count
  t.string :created_at
  t.string :email
  t.string :first_name
  t.string :last_name
  t.string :last_order_name
  t.string :state
  t.string :tags
  t.string :total_spent
  t.string :updated_at
  t.text :note
  t.references :order
  t.timestamps
end

create_table :default_address do |t|
  t.boolean :default
  t.integer :default_address_id
  t.string :address1
  t.string :address2
  t.string :city
  t.string :country
  t.string :country_code
  t.string :country_name
  t.string :name
  t.string :phone
  t.string :province
  t.string :province_code
  t.string :zip
  t.text :company
  t.text :first_name
  t.text :last_name
  t.references :customer
  t.timestamps
end

create_table :payment_details do |t|
  t.string :credit_card_company
  t.string :credit_card_number
  t.text :avs_result_code
  t.text :credit_card_bin
  t.text :cvv_result_code
  t.references :order
  t.timestamps
end

create_table :refunds do |t|
  t.references :order
  t.string :refunds
  t.timestamps
end

create_table :client_details do |t|
  t.string :browser_ip
  t.text :accept_language
  t.text :browser_height
  t.text :browser_width
  t.text :session_hash
  t.text :user_agent
  t.references :order
  t.timestamps
end

create_table :fulfillments do |t|
  t.references :order
  t.string :fulfillments
  t.timestamps
end

create_table :shipping_address do |t|
  t.float :latitude
  t.float :longitude
  t.string :address1
  t.string :address2
  t.string :city
  t.string :country
  t.string :country_code
  t.string :first_name
  t.string :last_name
  t.string :name
  t.string :phone
  t.string :province
  t.string :province_code
  t.string :zip
  t.text :company
  t.references :order
  t.timestamps
end

create_table :billing_address do |t|
  t.float :latitude
  t.float :longitude
  t.string :address1
  t.string :address2
  t.string :city
  t.string :country
  t.string :country_code
  t.string :first_name
  t.string :last_name
  t.string :name
  t.string :phone
  t.string :province
  t.string :province_code
  t.string :zip
  t.text :company
  t.references :order
  t.timestamps
end

create_table :shipping_lines do |t|
  t.references :order
  t.string :shipping_lines
  t.timestamps
end

create_table :line_items do |t|
  t.references :order
  t.string :line_items
  t.timestamps
end

create_table :tax_lines do |t|
  t.references :order
  t.string :tax_lines
  t.timestamps
end

create_table :note_attributes do |t|
  t.references :order
  t.string :note_attributes
  t.timestamps
end

create_table :discount_codes do |t|
  t.references :order
  t.string :discount_codes
  t.timestamps
end
```
