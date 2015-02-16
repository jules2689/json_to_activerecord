require 'active_support/inflector'

class Table
  attr_accessor :name, :parent, :rows, :json, :multi_entry_table

  def initialize(name, json, parent=nil, multi_entry_table=false)
    self.name = name
    self.parent = parent
    self.json
    self.multi_entry_table = multi_entry_table
    self.rows = []
  end

  def add_row(row)
    self.rows << row
    self.rows.sort! { |a,b| a.row_type <=> b.row_type }
  end

  def print
    puts "create_table :#{name.downcase.gsub(/ /,"_")} do |t|"
    rows.each do |row|
      row.print
    end
    puts "  t.references :#{parent.name}, index: true" if parent
    puts "  t.timestamps"
    puts "end"
  end

  def print_parser
    if self.multi_entry_table && rows.size == 1
      print_multi_array_table
    elsif self.multi_entry_table
      print_multi_hash_table
    else
      print_normal_table
    end
  end

  def row_names
    "#{name}-#{rows.collect(&:name)}"
  end

  private

  def print_multi_array_table
    first_row = rows.first
    puts "#{json_entry_name(first_row, true)}.each do |entry|"
    puts "  #{first_row.name.downcase.singularize} = #{first_row.name.camelcase.singularize}.new"
    puts "  #{first_row.name.downcase.singularize}.#{first_row.name} = entry"
    puts "  #{name.downcase.singularize}.save"
    puts "end"
  end

  def print_multi_hash_table
    first_row = Row.new("", nil, false, self)
    puts "#{json_entry_name(first_row, true)}.each do |entry|"
      puts "  #{name.downcase.singularize} = #{name.camelcase.singularize}.new"
      self.rows.each do |row|
        puts "  #{name.downcase.singularize}.#{row.name} = entry['#{row.name}']"
      end
      puts "  #{name.downcase.singularize}.#{parent.name} = #{parent.name.downcase.singularize}" if parent
      puts "  #{name.downcase.singularize}.save"
    puts "end"
  end

  def print_normal_table
    puts "#{name.downcase.singularize} = #{name.camelcase.singularize}.new"
    self.rows.each do |row|
      puts "#{name.downcase.singularize}.#{row.name} = #{json_entry_name(row)}"
    end
    puts "#{name.downcase.singularize}.#{parent.name} = #{parent.name.downcase.singularize}" if parent
    puts "#{name.downcase.singularize}.save"
  end


  def json_entry_name(row, pluralize_table_names=false)
    table = row.table
    entry = ""

    if pluralize_table_names && row.name
      entry = "['#{row.name.pluralize}']"
    elsif row.name
      entry = "['#{row.name}']"
    end

    if table.parent
      entry = "['#{table.name}']" + entry
      while (table.parent)
        if table.parent.parent
          entry = "['#{table.parent.name}']" + entry
        else
          entry = "#{table.parent.name}" + entry
        end
        table = table.parent
      end
    else
      entry = "#{table.name}" + entry
    end

    entry
  end
end