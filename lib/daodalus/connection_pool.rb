require 'singleton'

module Daodalus
  class ConnectionPool
    include Singleton

    def [](conn)
      connections.fetch(conn.to_s) { raise InvalidConnectionError }
    end

    def connections
      @connections ||= Hash[config.map { |name, conf| [name, Connection.new(conf)] }]
    end

    def config
      Configuration.config
    end

  end

  class InvalidConnectionError < StandardError
  end
end

