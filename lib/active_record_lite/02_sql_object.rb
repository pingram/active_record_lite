require 'debugger'
require_relative 'db_connection'
require_relative '01_mass_object'
require 'active_support/inflector'

ActiveSupport::Inflector.inflections do |inflect|
  inflect.irregular 'human', 'humans'
end

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
    result = DBConnection.instance.execute2("SELECT * FROM #{self.table_name} LIMIT 1")

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
    @table_name ||= self.to_s.underscore.pluralize
  end

  def self.all
    # XXX update the SQL query to not involve string interpolation
    query = <<-SQL
      SELECT
        *
      FROM
        #{self.table_name}
    SQL

    self.parse_all(DBConnection.instance.execute(query))
  end

  def self.find(id)

    table_n = self.table_name

    query = <<-SQL
      SELECT
        *
      FROM
        #{table_n}
      WHERE
        #{table_n}.id = #{id}
      LIMIT
        1
    SQL

    self.parse_all(DBConnection.instance.execute(query)).first
  end

  def attributes
    @attributes ||= {}
  end

  def insert
    table_n = self.class.table_name
    col_names = self.class.columns.map(&:to_s)[1..-1].join(', ')
    attr_values = self.attribute_values[1..-1]
    question_marks = (["?"] * attr_values.count).join(', ')

    query = <<-SQL
      INSERT INTO
        #{table_n}(#{col_names})
      VALUES
        (#{question_marks})
    SQL

    DBConnection.instance.execute(query, attr_values)
    self.id = Cat.all.last.id
  end

  def initialize(hash = {})
    # need to call columns so that we have attr_accessors XXX is this true?
    columns = self.class.columns

    @attributes = {}
    @attributes[:id] = nil

    hash.each do |attr, val|
      @attributes[attr.to_sym] = val
    end
  end

  def save
    if self.id.nil?
      insert
    else
      update
    end
  end

  def update
    table_n = self.class.table_name
    id = self.attribute_values.first
    attr_values = self.attribute_values[1..-1]

    query_vals = attr_values + [id]

    set_line = self.class.columns[1..-1].map do |col|
      "#{col.to_s} = ?"
    end.join(', ')

    query = <<-SQL
      UPDATE
        #{table_n}
      SET
        #{set_line}
      WHERE
        id = ?
    SQL

    DBConnection.instance.execute(query, query_vals)
  end

  # returns an array of all the column names
  def attribute_values
    attribute_values = []
    # p @attributes

    attributes.each do |key, val|
      attribute_values << val
    end

    attribute_values
  end
end