module Daodalus

  class Connection
  end

  def self.connections
    @connections ||= {}
  end

end
