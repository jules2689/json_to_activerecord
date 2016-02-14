require 'active_support/inflector'

class Table
  attr_accessor :name, :parent, :children, :rows, :json, :multi_entry_table

  def initialize(name, json, parent=nil, multi_entry_table=false)
    self.name = name
    self.parent = parent
    self.json = json
    self.multi_entry_table = multi_entry_table
    self.rows = []
    self.children = []

    parent.children << self if parent
  end

  def constant_name
    name.camelcase.singularize.gsub(/\s/,'')
  end

  def add_row(row)
    self.rows << row
    self.rows.sort! { |a,b| a.row_type <=> b.row_type }
  end

  def to_migration
    output = []
    output << "class Create#{constant_name.pluralize} < ActiveRecord::Migration"
    output << "  create_table :#{name.downcase.gsub(/ /,"_")} do |t|"
    rows.each do |row|
      output << "    #{row.to_table_row}"
    end
    output << "    t.references :#{parent.name}, index: true" if parent
    output << "    t.timestamps  null: false"
    output << "  end"
    output << "end"
    output.flatten.join("\n")
  end

  def to_parser
    if self.multi_entry_table && rows.size == 1
      output = to_multi_array_table
    elsif self.multi_entry_table
      output = to_multi_hash_table
    else
      output = to_basic_table
    end
    output.flatten.join("\n")
  end

  def to_model
    output = []
    output << "class #{constant_name} < ActiveRecord::Base"
    output << "  belongs_to :#{parent.name.singularize}" if parent

    # Children will introduce has_many and has_one relationships, find/sort/output those
    children_output = []
    children.each do |child|
      if child.multi_entry_table
        children_output << "  has_many :#{child.name.pluralize}"
      else
        children_output << "  has_one :#{child.name.singularize}"
      end
    end
    children_output.sort!
    output = output + children_output

    output << "end"
    output.flatten.join("\n")
  end

  def row_names
    "#{name}-#{rows.collect(&:name)}"
  end

  private

  def to_multi_array_table
    first_row = rows.first
    entry_name = first_row.name.downcase.singularize.parameterize
    output = []

    output << "#{json_entry_name(first_row, true)}.each do |entry|"
    output << "  #{entry_name} = #{first_row.constant_name}.new"
    output << "  #{entry_name}.#{first_row.name} = entry"
    output << parent_row(entry_name, "  ") if parent
    output << "  #{entry_name}.save"
    output << "end"
    output
  end

  def to_multi_hash_table
    first_row = Row.new("", nil, false, self)
    entry_name = name.downcase.singularize.parameterize
    output = []

    output << "#{json_entry_name(first_row, true)}.each do |entry|"
    output << "  #{entry_name} = #{constant_name}.new"
    self.rows.each do |row|
      output << "  #{entry_name}.#{row.name} = entry['#{row.name}']"
    end
    output << parent_row(entry_name, "  ") if parent
    output << "  #{entry_name}.save"
    output << "end"
    output
  end

  def to_basic_table
    entry_name = name.downcase.singularize.parameterize
    output = []

    output << "#{entry_name} = #{constant_name}.new"
    self.rows.each do |row|
      output << "#{entry_name}.#{row.name} = #{json_entry_name(row)}"
    end
    output << parent_row(entry_name) if parent
    output << "#{entry_name}.save"
    output
  end

  def parent_row(entry_name, spacer="")
    "#{spacer}#{entry_name}.#{parent.name.singularize} = #{parent.name.singularize}"
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