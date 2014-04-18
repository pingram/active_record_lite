require 'debugger'
require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

class MassObject
  def self.parse_all(results)
    new_objects = []
    # self is class
    results.each do |hash|
      new_obj = self.new
      hash.each do |attr, val|
        inst_var = "@" + attr.to_s
        instance_variable_set(inst_var, val)
      end
      new_objects << new_obj
    end

    new_objects
  end
end

class SQLObject < MassObject
  def self.columns
    result = DBConnection.instance.execute2("SELECT * FROM cats")

    columns = result.first.map(&:to_sym)
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
    # ...
  end

  def insert
    # ...
  end

  def initialize
    # ...
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
# Cat.new
Cat.columns