require 'simplecov'
require 'rspec'
require 'daodalus'
require_relative 'support/all'

SimpleCov.start do
  add_filter '/spec'
end

Daodalus::Configuration.load('spec/support/test_config.yml', :test)

RSpec.configure do |config|
  config.order = :rand
  config.color_enabled = true

  config.filter_run :focus => true
  config.run_all_when_everything_filtered = true
end

