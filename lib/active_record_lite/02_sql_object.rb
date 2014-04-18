require 'debugger'
require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject
  def self.parse_all(results)
    new_objects = []

    results.each do |hash|

      new_objects << self.new(hash)

    end
    new_objects
  end

end

class SQLObject < MassObject
  def self.columns
    result = DBConnection.instance.execute2("SELECT * FROM cats")

    columns = result.first.map(&:to_sym)

    columns.each do |name|
      define_method(name) do
        attributes[name]
      end

      define_method("#{name}=".to_sym) do |arg|
        attributes[name] = arg
      end
    end

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

  def initialize(hash)
    # need to call columns so that we have attr_accessors XXX is this true?
    columns = self.class.columns

    @attributes = hash

    # hash.each do |attr, val|
      # inst_var = "@" + attr.to_s
      # instance_variable_set(inst_var, val)
    # end
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

cats = Cat.parse_all(hashes)
p cats
p cats[0].name


# c = Cat.new(name: 'cat1', owner_id: 1)
# p c

# Cat.columns
# p cats.first.methods.sort
# Cat.columns
# p cats.first.name