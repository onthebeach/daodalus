require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'rspec'
require 'daodalus'
require_relative 'support/all'

Daodalus::Configuration.load('spec/support/test_config.yml', :test)

class DBCleaner
  def self.clean
    Daodalus::Pool.instance.connections.each do |_, conn|
      conn.drop_database
    end
  end
end

require_relative 'support/cat_dao'

RSpec.configure do |config|
  config.order = :rand
  config.color_enabled = true
  config.before(:all) { DBCleaner.clean }
end


