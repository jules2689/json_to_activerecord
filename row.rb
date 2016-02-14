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
    s = s + ", index: true" if self.indexed
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
      puts "Had an issue with the column \"#{key}\" in \"#{table}\", check the row's type"
      "integer"
    elsif key.include?("_at")
      puts "Had an issue with the column \"#{key}\" in \"#{table}\", check the row's type"
      "datetime"
    else
      puts "Had an issue with the column \"#{key}\" in \"#{table}\", check the row's type"
      "text"
    end
  end
end