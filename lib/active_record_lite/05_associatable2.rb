require_relative '04_associatable'
require 'ruby-debug'

# Phase V
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
  	through_options = assoc_options[through_name]
  	define_method(name) do

  		source_options = through_options.model_class.assoc_options[source_name]

  		fk_val = self.send(through_options.foreign_key)

  		select = "#{source_options.table_name}.*"
  		from = "#{through_options.table_name}"
  		join = "#{source_options.table_name}" +
  						" ON " +
  						"#{through_options.table_name}." +
  						"#{source_options.foreign_key}" +
  						" = " +
  						"#{source_options.table_name}." +
  						"#{source_options.primary_key}"
  		where_q = "#{through_options.table_name}" +
  						".#{through_options.primary_key}" +
  						" = " +
  						"#{fk_val}"
  		query_options = [select, from, join, where_q]

  		query = <<-SQL
  			SELECT
				  #{select}
				FROM
				  #{from}
				JOIN
				  #{join}
				WHERE
				  #{where_q}
  		SQL
  		# query = <<-SQL				XXX - get SQL injection to work
  		# 	SELECT
				#   ?
				# FROM
				#   ?
				# JOIN
				#   ?
				# WHERE
				#   ?
  		# SQL

  		source_options.model_class
  			.parse_all(DBConnection.instance.execute(query)).first
  	end
  end
end
