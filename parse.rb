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
    self.tables.reverse!
  end

  private

  def row_for_key_and_value(table, key, value)
    var_type = Row.column_type_for_value(table.name, key, value)
    key = key.to_s

    if var_type == "hash" # This is a sub table, process it as such
      process_new_table(key, value, table)
      nil
    elsif var_type == "array" # This is a special case of a sub table
      new_table = Table.new(key, value, table, true)
      new_table.add_row(Row.new("string", key.singularize, key.include?("_id"), table))
      self.tables << new_table
      nil
    else
      row = Row.new(var_type, key, key.include?("_id"), table)
      row
    end
  end

  def process_table(name, entries, parent=nil)
    table = Table.new(name, entries, parent)
    entries.map do |key, value|
      row = row_for_key_and_value(table, key, value)
      table.add_row(row) if row
    end
    self.tables << table
  end

  def process_new_table(name, entries, parent=nil)
    if name.downcase == "hours"
      process_table("day_hours", { open: "", close: "" }, parent) # Special case
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

j.tables.each do |t|
  t.print_parser
  puts "\n\n"
end
