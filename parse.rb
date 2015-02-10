#!/usr/bin/env ruby

require 'json'
require 'pry'

class JsonToActiveRecord
  attr_accessor :tables

  def initialize
    self.tables = []
    json = JSON.parse(File.read("data.json"))
    main_table_name = "table"

    if json.count == 1
      main_table_name = json.first.first
      json = json.first.last
    elsif json.count == 2
      main_table_name = json.first
      json = json.last
    else
      puts "What is the name name?"
      main_table_name = gets.chomp
    end

    process_table(main_table_name, json)
    self.tables.reverse!
  end

  private

  def name_for_key(table, key)
    if key == "type"
      "#{table}_type"
    elsif key == "id"
      "#{table}_id"
    else
      key
    end
  end

  def column_type_for_value(table, key, value)
    class_type = value.class
    if class_type == String
      value.length > 200 ? "text" : "string"
    elsif class_type == Fixnum
      "integer"
    elsif class_type == TrueClass
      "boolean"
    elsif class_type == FalseClass
      "boolean"
    elsif class_type == Float
      "float"
    elsif class_type == Hash
      "hash"
    elsif class_type == Array
      "array"
    elsif key.include?("_id")
      puts "Had an issue with the column \"#{key}\" in \"#{table}\", check it's type"
      "integer"
    elsif key.include?("_at")
      puts "Had an issue with the column \"#{key}\" in \"#{table}\", check it's type"
      "datetime"
    else
      puts "Had an issue with the column \"#{key}\" in \"#{table}\", check it's type"
      "text"
    end
  end

  def row_for_key_and_value(table_name, key, value)
    var_type = column_type_for_value(table_name, key, value)
    key = key.to_s

    if var_type == "hash" # This is a sub table, process it as such
      process_new_table(key, value, table_name)
      nil
    elsif var_type == "array" # This is a special case of a sub table
      tables << ["create_table :#{key} do |t|", "  t.references :#{table_name}", "  t.string :#{key}", "  t.timestamps", "end"].join("\n")
      nil
    else
      key_name = name_for_key(table_name, key).downcase.gsub(/(\s|-)/,"_")
      entry = "  t.#{var_type} :#{key_name}"
      entry = entry + ", index: true" if key.include?("_id")
      entry
    end
  end

  def process_table(name, entries, parent=nil)
    table = ["create_table :#{name.downcase.gsub(/ /,"_")} do |t|"]
    table = table + entries.collect { |key, value| row_for_key_and_value(name, key, value) }.compact.sort
    table << "  t.references :#{parent}" if parent
    table << "  t.timestamps"
    table << "end"
    self.tables << table.compact.join("\n")
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
puts j.tables.join("\n\n")