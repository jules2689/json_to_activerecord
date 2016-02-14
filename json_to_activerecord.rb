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

    case json.count
    when 1
      main_table_name = json.first.first
      json = json.first.last
    when 2
      main_table_name = json.first
      json = json.last
    else
      puts "What is the name?"
      main_table_name = gets.chomp
    end

    process_table(main_table_name, json)
    self.tables.uniq!(&:row_names)
    self.tables.reverse! # Main table is gonna be the parent of everything, so print that first
  end

  private

  def row_for_key_and_value(table, key, value)
    var_type = Row.column_type_for_value(table.name, key, value)
    key = key.to_s

    case var_type
    when "hash" # Hash will be a new table, with 1-1 relationship
      process_new_table(key, value, table)
      nil
    when "array" # Array will be a new table with 1-n relationship
      first_var_type = Row.column_type_for_value(table.name, key, value.first)
      if first_var_type == "hash"
        process_table(key, value.first, table, true)
      else
        new_table = Table.new(key, value, table, true)
        new_table.add_row(Row.new("text", key.singularize, key.include?("_id"), table))
        self.tables << new_table
      end
      nil
    else
      row = Row.new(var_type, key, key.include?("_id"), table)
      row
    end
  end

  def process_table(name, entries, parent=nil, multi_table=false)
    table = Table.new(name.underscore.pluralize, entries, parent, multi_table)
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

def remove_directory_content(dir_path)
  Dir.foreach(dir_path) {|f| fn = File.join(dir_path, f); File.delete(fn) if f != '.' && f != '..'}
end

def write_to_file(dir, file_name, content)
  puts "Writing to #{dir}/#{file_name}"
  File.open("#{dir}/#{file_name}", 'w') { |file| file.write(content) }
end
