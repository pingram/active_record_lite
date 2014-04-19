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
    unless @class_name == "Human"
      @class_name.underscore.pluralize
    else
      "humans"
    end
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
    options = BelongsToOptions.new(name, options)
    # p options
    p options.foreign_key
    p self.send(options.foreign_key)
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

class Human < SQLObject
end

h = Human.all.first
p h