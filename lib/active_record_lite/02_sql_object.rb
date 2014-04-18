require 'debugger'
require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject
  def self.parse_all(results)
    new_objects = []
    # self is class

    # p self.methods.count
    # # make attribute accessors for each column
    # # self.make_attr_accessors(self.columns)
    # p self.methods.count

    results.each do |hash|

      new_objects << self.new(hash)
    #   new_obj = self.new

    #   # debugger

    #   hash.each do |attr, val|
    #     inst_var = "@" + attr.to_s
    #     instance_variable_set(inst_var, val)
    #   end

    #   new_objects << new_obj
    # end

    end
    new_objects
  end

  # def self.make_attr_accessors(columns_arr)

  # end

end

class SQLObject < MassObject
  def self.columns
    result = DBConnection.instance.execute2("SELECT * FROM cats")

    columns = result.first.map(&:to_sym)

    p self.methods.count
    columns.each do |name|
      define_method(name) do
        attributes[name]
      end

      p name
      # puts "made getter '#{name}' for #{self}"

      define_method("#{name}=".to_sym) do |arg|
        attributes[name] = arg
      end
      # puts "made setter '#{name}' for #{self}"
    end
    p self.methods.count

    columns
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    # does not work for human (i.e. humen) XXX
    @table_name ||= self.to_s.underscore.pluralize
  end

  def self.all
    # ...
  end

  def self.find(id)
    # ...
  end

  def attributes
    @attributes ||= {}
  end

  def insert
    # ...
  end

  def initialize(*args)
    columns = self.class.columns
    # columns_s = columns.map(&:to_s)
    # p columns_s
    columns.each do |args|

    end
  end

  def save
    # ...
  end

  def update
    # ...
  end

  def attribute_values
    # ...
  end
end

class Cat < SQLObject
end

# c = Cat.new      # puts "made setter '#{name}' for #{self}"
hashes = [
        { name: 'cat1', owner_id: 1 },
        { name: 'cat2', owner_id: 2 }
      ]

# cats = Cat.parse_all(hashes)

Cat.new

# Cat.columns
# p cats.first.methods.sort
# Cat.columns
# p cats.first.name