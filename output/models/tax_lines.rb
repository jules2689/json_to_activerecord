class TaxLine < ActiveRecord::Base
  belongs_to :order
end