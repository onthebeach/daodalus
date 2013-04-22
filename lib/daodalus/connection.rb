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

    def read
      config['read'].to_sym
    end

    def refresh_mode
      if config.fetch('refresh_mode', false) == 'sync'
        :sync
      else
        false
      end
    end

    def refresh_interval
      config.fetch('refresh_interval', 90).to_i
    end

    def safe
      config['safe'].each_with_object({}) do |(key, value), hash|
        hash[key.to_sym] = value
      end
    end

    def single_server_options
      servers.flat_map { |s| [s['host'], s['port']] } + [{
        :pool_size => pool_size,
        :pool_timeout => timeout,
      }]
    end

    def multi_server_options
      [servers.map { |s| "#{s['host']}:#{s['port']}" }] + [{
        :pool_size => pool_size,
        :pool_timeout => timeout,
        :refresh_mode => refresh_mode,
        :refresh_interval => refresh_interval,
        :read => read,
        :safe => safe
      }]
    end

    def sharded?
      config.fetch('sharded', false)
    end

    private

    def pool
      @pool ||= servers.count > 1 ? multi_server_connection : connection
    rescue Mongo::ConnectionFailure => e
      @pool = nil
      raise e
    end

    def multi_server_connection
      multi_server_client.new(*multi_server_options)
    end

    def multi_server_client
      sharded? ? Mongo::MongoShardedClient : Mongo::MongoReplicaSetClient
    end

    def connection
      Mongo::MongoClient.new(*single_server_options)
    end

  end
end

