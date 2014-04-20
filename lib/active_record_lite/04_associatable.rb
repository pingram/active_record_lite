require_relative '03_searchable'
require_relative '02_sql_object'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    @class_name.underscore.pluralize
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    defaults = {
      class_name: name.to_s.singularize.camelcase,
      foreign_key: (name.to_s + "_id").to_sym,
      primary_key: :id
    }
    new_options = defaults.merge(options)

    @class_name = new_options[:class_name]
    @foreign_key = new_options[:foreign_key]
    @primary_key = new_options[:primary_key]
    # p self
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    defaults = {
      class_name: name.to_s.singularize.camelcase,
      foreign_key: (self_class_name.singularize.underscore
                      .to_s + "_id").to_sym,
      primary_key: :id
    }
    new_options = defaults.merge(options)

    @class_name = new_options[:class_name]
    @foreign_key = new_options[:foreign_key]
    @primary_key = new_options[:primary_key]
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    # debugger
    bto = BelongsToOptions.new(name, options)
    # p options
    # options.foreign_key
    # p self
    # p self.class
    # debugger
    # self.send(new_options.foreign_key)
    debugger
    cols = self.columns
    debugger
    tn = bto.table_name
    mc = bto.model_class
    fk = send(bto.foreign_key)
    debugger

    define_method(name) do
      mc.where(id: fk)
    end
    # debugger
    # p self.owner
    # p self.send(:id)
  end

  def has_many(name, options = {})
    # ...
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
end

# class Human < SQLObject
#   extend Associatable
# end

# class Cat < SQLObject
#   extend Associatable
# end

# c = Cat.find(1)
# h = Human.find(1)
# p c
# p h
# p c.send(:name)

# b = BelongsToOptions.new("Human")

# h = Human.all.first
# h.belongs_to(:cat)