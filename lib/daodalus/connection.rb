module Daodalus
  class Connection

    def initialize(config)
      @config = config
    end

    def db
      @db ||= pool[database_name]
    end

    def config
      @config
    end

    def drop_database
      connection.drop_database(database_name)
    end

    def database_name
      config['database']
    end

    def pool_size
      config['pool_size'].to_i
    end

    def timeout
      config['timeout'].to_i
    end

    def servers
      config['servers']
    end

    def single_server_options
      servers.flat_map { |s| [s['host'], s['port']] } << {
        :pool_size => pool_size,
        :pool_timeout => timeout,
      }
    end

    def replica_set_options
      servers.map { |s| "#{s['host']}:#{s['port']}" } << {
        :pool_size => pool_size,
        :pool_timeout => timeout,
        :read => :primary
      }
    end

    private

    def pool
      @pool ||= servers.count > 1 ? replica_set_connection : connection
    rescue Mongo::ConnectionFailure => e
      @pool = nil
      raise e
    end

    def replica_set_connection
      Mongo::MongoReplicaSetClient.new(*replica_set_options)
    end

    def connection
      Mongo::MongoClient.new(*single_server_options)
    end

  end
end

