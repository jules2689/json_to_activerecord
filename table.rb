require 'active_support/inflector'

class Table
  attr_accessor :name, :parent, :rows, :json, :array_table

  def initialize(name, json, parent=nil, array_table=false)
    self.name = name
    self.parent = parent
    self.json
    self.array_table = array_table
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
    puts "  t.references :#{parent.name}" if parent
    puts "  t.timestamps"
    puts "end"
  end

  def print_parser
    if self.array_table
      first_row = rows.first
      puts "#{json_entry_name(first_row, true)}.each do |entry|"
      puts "  #{first_row.name.downcase.singularize} = #{first_row.name.camelcase.singularize}.new"
      puts "  #{first_row.name.downcase.singularize}.#{first_row.name} = entry"
      puts "  #{name.downcase.singularize}.save"
      puts "end"
    else
      puts "#{name.downcase.singularize} = #{name.camelcase.singularize}.new"
      self.rows.each do |row|
        puts "#{name.downcase.singularize}.#{row.name} = #{json_entry_name(row)}"
      end
      puts "#{name.downcase.singularize}.#{parent.name} = #{parent.name.downcase.singularize}" if parent
      puts "#{name.downcase.singularize}.save"
    end
  end

  def json_entry_name(row, pluralize_table_names=false)
    table = row.table
    if pluralize_table_names
      entry = "['#{row.name.pluralize}']"
    else
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