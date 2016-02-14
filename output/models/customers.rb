class Customer < ActiveRecord::Base
  belongs_to :order
  has_one :default_address
end