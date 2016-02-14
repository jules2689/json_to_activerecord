class BillingAddress < ActiveRecord::Base
  belongs_to :order
end