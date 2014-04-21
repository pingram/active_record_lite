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
    define_method(name) do
      bto = BelongsToOptions.new(name, options)
      mc = bto.model_class
      fk_val = self.send(bto.foreign_key)
      mc.where(bto.primary_key => fk_val).first
    end
  end

  def has_many(name, options = {})
    define_method(name) do
      hmo = HasManyOptions.new(name, self.class.table_name, options)
      mc = hmo.model_class
      fk_val = self.id
      mc.where(hmo.foreign_key => fk_val)
    end
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
  end
end

class SQLObject
  extend Associatable
end