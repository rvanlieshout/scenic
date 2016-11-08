module Scenic
  module Adapters
    class MySQL
      # Raised when a materialized view operation is attempted on a database
      # version that does not support materialized views.
      #
      # Materialized views are supported on Postgres 9.3 or newer.
      class MaterializedViewsNotSupportedError < StandardError
        def initialize
          super("Materialized views not yet supported for MySQL")
        end
      end
    end
  end
end
