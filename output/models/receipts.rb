class Receipt < ActiveRecord::Base
  belongs_to :fulfillment
end