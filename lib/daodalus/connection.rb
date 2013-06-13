module Daodalus

  module Connection
    extend self

    def register(connection, name='default')
      connections[name.to_s] = connection
    end

    def fetch(name='default')
      connections.fetch(name.to_s) { raise InvalidConnectionError.new(name) }
    end

    private

    def connections
      @connections ||= {}
    end

  end

  class InvalidConnectionError < StandardError
    def initialize(name)
      super("Daodalus::InvalidConnectionError - #{name.inspect}")
    end
  end

end
