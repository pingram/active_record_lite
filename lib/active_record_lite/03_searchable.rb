require_relative 'db_connection'
require_relative '02_sql_object'

module Searchable
  def where(params)
		table_n = self.table_name
    where_string = params.keys.map(&:to_s).join(" = ? AND ") + " = ?"
    where_values = params.values

    query = <<-SQL
      SELECT
        *
      FROM
      	#{table_n}
      WHERE
        #{where_string}
    SQL

    self.parse_all(DBConnection.instance.execute(query, where_values))
  end
end

class SQLObject
  extend Searchable
end