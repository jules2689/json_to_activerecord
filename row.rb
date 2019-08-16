class Row
  attr_accessor :row_type, :name, :indexed, :table

  def initialize(row_type, key, indexed, table)
    self.row_type = row_type
    self.name = name_for_key(table.name, key).downcase.gsub(/(\s|-)/,"_") if key
    self.indexed = indexed
    self.table = table
  end

  def constant_name
    name.camelcase.singularize.gsub(/\s/,'')
  end

  def to_table_row
    s = "t.#{row_type} :#{name}"
    s << ", limit: 8" if row_type == "integer"
    s << ", index: true" if self.indexed
    s
  end

  def name_for_key(table, key)
    if ["type", "id", "updated_at", "created_at"].include?(key)
      "#{table}_#{key}"
    else
      key
    end
  end

  def self.column_type_for_value(table, key, value)
    case value.class.to_s
    when "String"
      value.length > 200 ? "text" : "string"
    when "Fixnum"
      "integer"
    when "TrueClass", "FalseClass"
      "boolean"
    when "Float"
      "float"
    when "Hash"
      "hash"
    when "Array"
      "array"
    when "Integer"
      "integer"
    else
      if key.end_with?("_id") || key == "id" || key.end_with?("_count")
        puts "Had an issue with the column \"#{key}\" in \"#{table}\", check the row's type"
        "integer"
      elsif key.end_with?("_at")
        puts "Had an issue with the column \"#{key}\" in \"#{table}\", check the row's type"
        "datetime"
      else # Default to text to hold anything
        puts "Had an issue with the column \"#{key}\" in \"#{table}\", check the row's type"
        "text"
      end
    end
  end
end