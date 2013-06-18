require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'rspec'
require 'daodalus'

require 'support/mongo_cleaner'

RSpec.configure do |config|
  config.order = :rand
  config.color_enabled = true
  config.before(:each) { MongoCleaner.clean }
end

conn = Mongo::MongoClient.new('localhost', 27017, pool_size: 5, pool_timeout: 5)
Daodalus::Connection.register(conn)
