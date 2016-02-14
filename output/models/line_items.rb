class LineItem < ActiveRecord::Base
  belongs_to :order
  has_many :properties
  has_many :tax_lines
end