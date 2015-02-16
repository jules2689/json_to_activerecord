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
create_table :billing_address do |t|
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
  t.references :order, index: true
  t.timestamps
end


create_table :client_details do |t|
  t.string :browser_ip
  t.text :browser_width
  t.text :accept_language
  t.text :browser_height
  t.text :session_hash
  t.text :user_agent
  t.references :order, index: true
  t.timestamps
end


create_table :customer do |t|
  t.boolean :accepts_marketing
  t.boolean :verified_email
  t.integer :customer_id
  t.integer :multipass_identifier, index: true
  t.integer :orders_count
  t.integer :last_order_id, index: true
  t.string :email
  t.string :state
  t.string :customer_created_at
  t.string :customer_updated_at
  t.string :last_name
  t.string :last_order_name
  t.string :first_name
  t.string :total_spent
  t.string :tags
  t.text :note
  t.references :order, index: true
  t.timestamps
end


create_table :default_address do |t|
  t.boolean :default
  t.integer :default_address_id
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
  t.references :customer, index: true
  t.timestamps
end


create_table :discount_codes do |t|
  t.string :code
  t.string :amount
  t.string :discount_codes_type
  t.references :order, index: true
  t.timestamps
end


create_table :fulfillments do |t|
  t.integer :fulfillments_id
  t.integer :order_id, index: true
  t.string :status
  t.string :fulfillments_created_at
  t.string :service
  t.string :tracking_number
  t.string :tracking_url
  t.string :fulfillments_updated_at
  t.text :tracking_company
  t.references :order, index: true
  t.timestamps
end


create_table :line_item do |t|
  t.boolean :gift_card
  t.boolean :requires_shipping
  t.boolean :taxable
  t.boolean :product_exists
  t.integer :grams
  t.integer :line_item_id
  t.integer :product_id, index: true
  t.integer :variant_id, index: true
  t.integer :quantity
  t.integer :fulfillable_quantity
  t.string :sku
  t.string :price
  t.string :name
  t.string :variant_inventory_management
  t.string :fulfillment_service
  t.string :variant_title
  t.string :title
  t.text :fulfillment_status
  t.text :vendor
  t.references :refund_line_items, index: true
  t.timestamps
end


create_table :line_items do |t|
  t.boolean :gift_card
  t.boolean :requires_shipping
  t.boolean :taxable
  t.boolean :product_exists
  t.integer :grams
  t.integer :line_items_id
  t.integer :product_id, index: true
  t.integer :variant_id, index: true
  t.integer :quantity
  t.integer :fulfillable_quantity
  t.string :sku
  t.string :price
  t.string :name
  t.string :variant_inventory_management
  t.string :fulfillment_service
  t.string :variant_title
  t.string :title
  t.text :fulfillment_status
  t.text :vendor
  t.references :order, index: true
  t.timestamps
end


create_table :note_attributes do |t|
  t.string :name
  t.string :value
  t.references :order, index: true
  t.timestamps
end


create_table :order do |t|
  t.boolean :buyer_accepts_marketing
  t.boolean :confirmed
  t.boolean :test
  t.boolean :taxes_included
  t.datetime :closed_at
  t.datetime :cancelled_at
  t.integer :order_id
  t.integer :device_id, index: true
  t.integer :location_id, index: true
  t.integer :number
  t.integer :total_weight
  t.integer :user_id, index: true
  t.integer :order_number
  t.integer :checkout_id, index: true
  t.string :email
  t.string :gateway
  t.string :financial_status
  t.string :source_name
  t.string :landing_site
  t.string :order_created_at
  t.string :token
  t.string :total_line_items_price
  t.string :reference
  t.string :subtotal_price
  t.string :order_updated_at
  t.string :currency
  t.string :landing_site_ref
  t.string :cart_token
  t.string :source
  t.string :total_price_usd
  t.string :tags
  t.string :processed_at
  t.string :source_identifier, index: true
  t.string :total_discounts
  t.string :referring_site
  t.string :total_price
  t.string :processing_method
  t.string :name
  t.string :total_tax
  t.text :fulfillment_status
  t.text :cancel_reason
  t.text :source_url
  t.text :checkout_token
  t.text :note
  t.text :browser_ip
  t.timestamps
end


create_table :payment_details do |t|
  t.string :credit_card_number
  t.string :credit_card_company
  t.text :cvv_result_code
  t.text :avs_result_code
  t.text :credit_card_bin
  t.references :order, index: true
  t.timestamps
end


create_table :properties do |t|
  t.string :name
  t.string :value
  t.references :line_items, index: true
  t.timestamps
end


create_table :properties do |t|
  t.string :property
  t.references :line_item, index: true
  t.timestamps
end


create_table :receipt do |t|
  t.boolean :testcase
  t.string :authorization
  t.references :fulfillments, index: true
  t.timestamps
end


create_table :receipt do |t|
  t.references :transactions, index: true
  t.timestamps
end


create_table :refund_line_items do |t|
  t.integer :refund_line_items_id
  t.integer :line_item_id, index: true
  t.integer :quantity
  t.references :refunds, index: true
  t.timestamps
end


create_table :refunds do |t|
  t.boolean :restock
  t.integer :order_id, index: true
  t.integer :refunds_id
  t.integer :user_id, index: true
  t.string :refunds_created_at
  t.string :note
  t.references :order, index: true
  t.timestamps
end


create_table :shipping_address do |t|
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
  t.references :order, index: true
  t.timestamps
end


create_table :shipping_lines do |t|
  t.string :code
  t.string :price
  t.string :source
  t.string :title
  t.references :order, index: true
  t.timestamps
end


create_table :tax_lines do |t|
  t.string :tax_line
  t.references :line_item, index: true
  t.timestamps
end


create_table :tax_lines do |t|
  t.float :rate
  t.string :price
  t.string :title
  t.references :order, index: true
  t.timestamps
end


create_table :tracking_numbers do |t|
  t.string :tracking_number
  t.references :fulfillments, index: true
  t.timestamps
end


create_table :tracking_urls do |t|
  t.string :tracking_url
  t.references :fulfillments, index: true
  t.timestamps
end


create_table :transactions do |t|
  t.boolean :test
  t.integer :parent_id, index: true
  t.integer :order_id, index: true
  t.integer :location_id, index: true
  t.integer :transactions_id
  t.integer :user_id, index: true
  t.integer :device_id, index: true
  t.string :transactions_created_at
  t.string :authorization
  t.string :currency
  t.string :gateway
  t.string :source_name
  t.string :status
  t.string :kind
  t.string :amount
  t.text :message
  t.text :error_code
  t.references :refunds, index: true
  t.timestamps
end


billing_address = BillingAddress.new
billing_address.latitude = order['billing_address']['latitude']
billing_address.longitude = order['billing_address']['longitude']
billing_address.country = order['billing_address']['country']
billing_address.last_name = order['billing_address']['last_name']
billing_address.city = order['billing_address']['city']
billing_address.address2 = order['billing_address']['address2']
billing_address.phone = order['billing_address']['phone']
billing_address.zip = order['billing_address']['zip']
billing_address.country_code = order['billing_address']['country_code']
billing_address.province_code = order['billing_address']['province_code']
billing_address.province = order['billing_address']['province']
billing_address.first_name = order['billing_address']['first_name']
billing_address.name = order['billing_address']['name']
billing_address.address1 = order['billing_address']['address1']
billing_address.company = order['billing_address']['company']
billing_address.order = order
billing_address.save


client_detail = ClientDetail.new
client_detail.browser_ip = order['client_details']['browser_ip']
client_detail.browser_width = order['client_details']['browser_width']
client_detail.accept_language = order['client_details']['accept_language']
client_detail.browser_height = order['client_details']['browser_height']
client_detail.session_hash = order['client_details']['session_hash']
client_detail.user_agent = order['client_details']['user_agent']
client_detail.order = order
client_detail.save


customer = Customer.new
customer.accepts_marketing = order['customer']['accepts_marketing']
customer.verified_email = order['customer']['verified_email']
customer.customer_id = order['customer']['customer_id']
customer.multipass_identifier = order['customer']['multipass_identifier']
customer.orders_count = order['customer']['orders_count']
customer.last_order_id = order['customer']['last_order_id']
customer.email = order['customer']['email']
customer.state = order['customer']['state']
customer.customer_created_at = order['customer']['customer_created_at']
customer.customer_updated_at = order['customer']['customer_updated_at']
customer.last_name = order['customer']['last_name']
customer.last_order_name = order['customer']['last_order_name']
customer.first_name = order['customer']['first_name']
customer.total_spent = order['customer']['total_spent']
customer.tags = order['customer']['tags']
customer.note = order['customer']['note']
customer.order = order
customer.save


default_address = DefaultAddress.new
default_address.default = order['customer']['default_address']['default']
default_address.default_address_id = order['customer']['default_address']['default_address_id']
default_address.country = order['customer']['default_address']['country']
default_address.address2 = order['customer']['default_address']['address2']
default_address.city = order['customer']['default_address']['city']
default_address.phone = order['customer']['default_address']['phone']
default_address.zip = order['customer']['default_address']['zip']
default_address.province_code = order['customer']['default_address']['province_code']
default_address.address1 = order['customer']['default_address']['address1']
default_address.country_name = order['customer']['default_address']['country_name']
default_address.province = order['customer']['default_address']['province']
default_address.country_code = order['customer']['default_address']['country_code']
default_address.name = order['customer']['default_address']['name']
default_address.last_name = order['customer']['default_address']['last_name']
default_address.first_name = order['customer']['default_address']['first_name']
default_address.company = order['customer']['default_address']['company']
default_address.customer = customer
default_address.save


order['discount_codes'].each do |entry|
  discount_code = DiscountCode.new
  discount_code.code = entry['code']
  discount_code.amount = entry['amount']
  discount_code.discount_codes_type = entry['discount_codes_type']
  discount_code.order = order
  discount_code.save
end


order['fulfillments'].each do |entry|
  fulfillment = Fulfillment.new
  fulfillment.fulfillments_id = entry['fulfillments_id']
  fulfillment.order_id = entry['order_id']
  fulfillment.status = entry['status']
  fulfillment.fulfillments_created_at = entry['fulfillments_created_at']
  fulfillment.service = entry['service']
  fulfillment.tracking_number = entry['tracking_number']
  fulfillment.tracking_url = entry['tracking_url']
  fulfillment.fulfillments_updated_at = entry['fulfillments_updated_at']
  fulfillment.tracking_company = entry['tracking_company']
  fulfillment.order = order
  fulfillment.save
end


line_item = LineItem.new
line_item.gift_card = order['refunds']['refund_line_items']['line_item']['gift_card']
line_item.requires_shipping = order['refunds']['refund_line_items']['line_item']['requires_shipping']
line_item.taxable = order['refunds']['refund_line_items']['line_item']['taxable']
line_item.product_exists = order['refunds']['refund_line_items']['line_item']['product_exists']
line_item.grams = order['refunds']['refund_line_items']['line_item']['grams']
line_item.line_item_id = order['refunds']['refund_line_items']['line_item']['line_item_id']
line_item.product_id = order['refunds']['refund_line_items']['line_item']['product_id']
line_item.variant_id = order['refunds']['refund_line_items']['line_item']['variant_id']
line_item.quantity = order['refunds']['refund_line_items']['line_item']['quantity']
line_item.fulfillable_quantity = order['refunds']['refund_line_items']['line_item']['fulfillable_quantity']
line_item.sku = order['refunds']['refund_line_items']['line_item']['sku']
line_item.price = order['refunds']['refund_line_items']['line_item']['price']
line_item.name = order['refunds']['refund_line_items']['line_item']['name']
line_item.variant_inventory_management = order['refunds']['refund_line_items']['line_item']['variant_inventory_management']
line_item.fulfillment_service = order['refunds']['refund_line_items']['line_item']['fulfillment_service']
line_item.variant_title = order['refunds']['refund_line_items']['line_item']['variant_title']
line_item.title = order['refunds']['refund_line_items']['line_item']['title']
line_item.fulfillment_status = order['refunds']['refund_line_items']['line_item']['fulfillment_status']
line_item.vendor = order['refunds']['refund_line_items']['line_item']['vendor']
line_item.refund_line_items = refund_line_item
line_item.save


order['line_items'].each do |entry|
  line_item = LineItem.new
  line_item.gift_card = entry['gift_card']
  line_item.requires_shipping = entry['requires_shipping']
  line_item.taxable = entry['taxable']
  line_item.product_exists = entry['product_exists']
  line_item.grams = entry['grams']
  line_item.line_items_id = entry['line_items_id']
  line_item.product_id = entry['product_id']
  line_item.variant_id = entry['variant_id']
  line_item.quantity = entry['quantity']
  line_item.fulfillable_quantity = entry['fulfillable_quantity']
  line_item.sku = entry['sku']
  line_item.price = entry['price']
  line_item.name = entry['name']
  line_item.variant_inventory_management = entry['variant_inventory_management']
  line_item.fulfillment_service = entry['fulfillment_service']
  line_item.variant_title = entry['variant_title']
  line_item.title = entry['title']
  line_item.fulfillment_status = entry['fulfillment_status']
  line_item.vendor = entry['vendor']
  line_item.order = order
  line_item.save
end


order['note_attributes'].each do |entry|
  note_attribute = NoteAttribute.new
  note_attribute.name = entry['name']
  note_attribute.value = entry['value']
  note_attribute.order = order
  note_attribute.save
end


order = Order.new
order.buyer_accepts_marketing = order['buyer_accepts_marketing']
order.confirmed = order['confirmed']
order.test = order['test']
order.taxes_included = order['taxes_included']
order.closed_at = order['closed_at']
order.cancelled_at = order['cancelled_at']
order.order_id = order['order_id']
order.device_id = order['device_id']
order.location_id = order['location_id']
order.number = order['number']
order.total_weight = order['total_weight']
order.user_id = order['user_id']
order.order_number = order['order_number']
order.checkout_id = order['checkout_id']
order.email = order['email']
order.gateway = order['gateway']
order.financial_status = order['financial_status']
order.source_name = order['source_name']
order.landing_site = order['landing_site']
order.order_created_at = order['order_created_at']
order.token = order['token']
order.total_line_items_price = order['total_line_items_price']
order.reference = order['reference']
order.subtotal_price = order['subtotal_price']
order.order_updated_at = order['order_updated_at']
order.currency = order['currency']
order.landing_site_ref = order['landing_site_ref']
order.cart_token = order['cart_token']
order.source = order['source']
order.total_price_usd = order['total_price_usd']
order.tags = order['tags']
order.processed_at = order['processed_at']
order.source_identifier = order['source_identifier']
order.total_discounts = order['total_discounts']
order.referring_site = order['referring_site']
order.total_price = order['total_price']
order.processing_method = order['processing_method']
order.name = order['name']
order.total_tax = order['total_tax']
order.fulfillment_status = order['fulfillment_status']
order.cancel_reason = order['cancel_reason']
order.source_url = order['source_url']
order.checkout_token = order['checkout_token']
order.note = order['note']
order.browser_ip = order['browser_ip']
order.save


payment_detail = PaymentDetail.new
payment_detail.credit_card_number = order['payment_details']['credit_card_number']
payment_detail.credit_card_company = order['payment_details']['credit_card_company']
payment_detail.cvv_result_code = order['payment_details']['cvv_result_code']
payment_detail.avs_result_code = order['payment_details']['avs_result_code']
payment_detail.credit_card_bin = order['payment_details']['credit_card_bin']
payment_detail.order = order
payment_detail.save


order['line_items']['properties'].each do |entry|
  property = Property.new
  property.name = entry['name']
  property.value = entry['value']
  property.line_items = line_item
  property.save
end


order['refunds']['refund_line_items']['line_item']['properties'].each do |entry|
  property = Property.new
  property.property = entry
  property.line_item = line_item
  property.save
end


receipt = Receipt.new
receipt.testcase = order['fulfillments']['receipt']['testcase']
receipt.authorization = order['fulfillments']['receipt']['authorization']
receipt.fulfillments = fulfillment
receipt.save


receipt = Receipt.new
receipt.transactions = transaction
receipt.save


order['refunds']['refund_line_items'].each do |entry|
  refund_line_item = RefundLineItem.new
  refund_line_item.refund_line_items_id = entry['refund_line_items_id']
  refund_line_item.line_item_id = entry['line_item_id']
  refund_line_item.quantity = entry['quantity']
  refund_line_item.refunds = refund
  refund_line_item.save
end


order['refunds'].each do |entry|
  refund = Refund.new
  refund.restock = entry['restock']
  refund.order_id = entry['order_id']
  refund.refunds_id = entry['refunds_id']
  refund.user_id = entry['user_id']
  refund.refunds_created_at = entry['refunds_created_at']
  refund.note = entry['note']
  refund.order = order
  refund.save
end


shipping_address = ShippingAddress.new
shipping_address.latitude = order['shipping_address']['latitude']
shipping_address.longitude = order['shipping_address']['longitude']
shipping_address.country = order['shipping_address']['country']
shipping_address.last_name = order['shipping_address']['last_name']
shipping_address.city = order['shipping_address']['city']
shipping_address.address2 = order['shipping_address']['address2']
shipping_address.phone = order['shipping_address']['phone']
shipping_address.zip = order['shipping_address']['zip']
shipping_address.country_code = order['shipping_address']['country_code']
shipping_address.province_code = order['shipping_address']['province_code']
shipping_address.province = order['shipping_address']['province']
shipping_address.first_name = order['shipping_address']['first_name']
shipping_address.name = order['shipping_address']['name']
shipping_address.address1 = order['shipping_address']['address1']
shipping_address.company = order['shipping_address']['company']
shipping_address.order = order
shipping_address.save


order['shipping_lines'].each do |entry|
  shipping_line = ShippingLine.new
  shipping_line.code = entry['code']
  shipping_line.price = entry['price']
  shipping_line.source = entry['source']
  shipping_line.title = entry['title']
  shipping_line.order = order
  shipping_line.save
end


order['refunds']['refund_line_items']['line_item']['tax_lines'].each do |entry|
  tax_line = TaxLine.new
  tax_line.tax_line = entry
  tax_line.line_item = line_item
  tax_line.save
end


order['tax_lines'].each do |entry|
  tax_line = TaxLine.new
  tax_line.rate = entry['rate']
  tax_line.price = entry['price']
  tax_line.title = entry['title']
  tax_line.order = order
  tax_line.save
end


order['fulfillments']['tracking_numbers'].each do |entry|
  tracking_number = TrackingNumber.new
  tracking_number.tracking_number = entry
  tracking_number.fulfillments = fulfillment
  tracking_number.save
end


order['fulfillments']['tracking_urls'].each do |entry|
  tracking_url = TrackingUrl.new
  tracking_url.tracking_url = entry
  tracking_url.fulfillments = fulfillment
  tracking_url.save
end


order['refunds']['transactions'].each do |entry|
  transaction = Transaction.new
  transaction.test = entry['test']
  transaction.parent_id = entry['parent_id']
  transaction.order_id = entry['order_id']
  transaction.location_id = entry['location_id']
  transaction.transactions_id = entry['transactions_id']
  transaction.user_id = entry['user_id']
  transaction.device_id = entry['device_id']
  transaction.transactions_created_at = entry['transactions_created_at']
  transaction.authorization = entry['authorization']
  transaction.currency = entry['currency']
  transaction.gateway = entry['gateway']
  transaction.source_name = entry['source_name']
  transaction.status = entry['status']
  transaction.kind = entry['kind']
  transaction.amount = entry['amount']
  transaction.message = entry['message']
  transaction.error_code = entry['error_code']
  transaction.refunds = refund
  transaction.save
end


~~~~~ WARNING/NOTICE:
~~~~~ You need to go through the output to make sure that duplicate tables get removed.
~~~~~ These cannot be programmatically removed as they may be presented slightly different in the JSON.
~~~~~ As always, double check the data that we have given!
~~~~~ The program cannot detect polymorhpic needs, so things like this can happen...

create_table :tax_lines do |t|
  t.string :tax_line
  t.references :line_item, index: true
  t.timestamps
end


create_table :tax_lines do |t|
  t.float :rate
  t.string :price
  t.string :title
  t.references :order, index: true
  t.timestamps
end

~~~~~ As you can see, these are the same 'tables' but the entries and owners are different!
~~~~~ BillingAddress and ShippingAddress (for example), may be the Address table, but are going to be different for this parser.
```
