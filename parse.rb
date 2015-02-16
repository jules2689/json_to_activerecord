#!/usr/bin/env ruby

require 'json'
require 'pry'
require 'active_support/inflector'

require_relative 'table'
require_relative 'row'

class JsonToActiveRecord
  attr_accessor :tables, :parsing, :current_parse

  def initialize
    self.tables = []
    self.parsing = []

    json = JSON.parse(File.read("data.json"))
    main_table_name = "table"

    if json.count == 1
      main_table_name = json.first.first
      json = json.first.last
    elsif json.count == 2
      main_table_name = json.first
      json = json.last
    else
      puts "What is the name?"
      main_table_name = gets.chomp
    end

    process_table(main_table_name, json)
    self.tables.sort! { |a,b| a.name <=> b.name }
    self.tables.uniq!(&:row_names)
  end

  private

  def row_for_key_and_value(table, key, value)
    var_type = Row.column_type_for_value(table.name, key, value)
    key = key.to_s

    if var_type == "hash" # This is a sub table, process it as such
      process_new_table(key, value, table)
      nil
    elsif var_type == "array" # This is a special case of a sub table
      first_var_type = Row.column_type_for_value(table.name, key, value.first)
      if first_var_type == "hash"
        process_table(key, value.first, table, true)
      else
        new_table = Table.new(key, value, table, true)
        new_table.add_row(Row.new("string", key.singularize, key.include?("_id"), table))
        self.tables << new_table
      end
      nil
    else
      row = Row.new(var_type, key, key.include?("_id"), table)
      row
    end
  end

  def process_table(name, entries, parent=nil, multi_table=false)
    table = Table.new(name, entries, parent, multi_table)
    entries.map do |key, value|
      row = row_for_key_and_value(table, key, value)
      table.add_row(row) if row
    end
    self.tables << table
  end

  def process_new_table(name, entries, parent=nil)
    if name.downcase == "hours"
      process_table("day_hours", { open: "", close: "" }, parent, true) # Special case
    else
      process_table(name, entries, parent)
    end
  end
end

j = JsonToActiveRecord.new
puts "\n\n"

j.tables.each do |t|
  t.print
  puts "\n\n"
end

sleep 0.5

j.tables.each do |t|
  t.print_parser
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
