class Customer < ActiveRecord::Base
  belongs_to :order
  has_many :default_addresses
end