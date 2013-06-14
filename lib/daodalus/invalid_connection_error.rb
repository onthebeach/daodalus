module Daodalus
  class InvalidConnectionError < StandardError
    def initialize(name)
      super("Daodalus::InvalidConnectionError - #{name.inspect}")
    end
  end
end
