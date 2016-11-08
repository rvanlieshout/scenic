module Scenic
  module Adapters
    class MySQL
      # Fetches defined views from the postgres connection.
      # @api private
      class Views
        def initialize(connection)
          @connection = connection
        end

        # All of the views that this connection has defined.
        #
        # This will include materialized views if those are supported by the
        # connection.
        #
        # @return [Array<Scenic::View>]
        def all
          views_from_mysql.map(&method(:to_scenic_view))
        end

        private

        attr_reader :connection

        def views_from_mysql
          connection.execute(<<-SQL)
            SHOW FULL TABLES WHERE TABLE_TYPE LIKE 'VIEW'
          SQL
        end

        def view_defenition(viewname)
          connection.execute(%(
            SHOW CREATE VIEW #{viewname}
          )).first[1]
            .strip
            .sub(%r{^CREATE.*?AS\s*}, '')
        end

        def to_scenic_view(result)
          viewname, _table_type = result

          Scenic::View.new(
            name: viewname,
            definition: view_defenition(viewname).strip,
            materialized: false
          )
        end
      end
    end
  end
end
