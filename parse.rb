#!/usr/bin/env ruby

require 'json'
require 'pry'
require_relative 'json_to_activerecord'

j = JsonToActiveRecord.new

puts "Writing migrations to 'output/migrations'"
dir = "output/migrations"
remove_directory_content(dir)
time = Time.now

j.tables.each do |t|
  time += 1

  table_content = t.to_migration
  time_stamp = time.strftime("%Y%m%d%H%M%S")
  file_name = "#{time_stamp}_create_#{t.name}.rb"
  write_to_file(dir, file_name, table_content)
end

puts "\n\nWriting models to 'output/models'"
dir = "output/models"
remove_directory_content(dir)
j.tables.each do |t|
  model_content = t.to_model
  file_name = "#{t.name}.rb"
  write_to_file(dir, file_name, model_content)
end

puts "Here are parsers to parse the json\n\n"
j.tables.each do |t|
  puts t.to_parser
  puts "\n\n"
end

puts "~~~~~ WARNING/NOTICE:"
puts "~~~~~ You need to go through the output to make sure that duplicate tables get removed."
puts "~~~~~ These cannot be programmatically removed as they may be presented slightly different in the JSON."
puts "~~~~~ As always, double check the data that we have given!"
puts "~~~~~ The program cannot detect polymorhpic needs, so things like this can happen..."
puts """
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

"""
puts "~~~~~ As you can see, these are the same 'tables' but the entries and owners are different!"
puts "~~~~~ BillingAddress and ShippingAddress (for example), may be the Address table, but are going to be different for this parser."
