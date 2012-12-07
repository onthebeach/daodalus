require 'singleton'
require 'yaml'
require 'erb'

module Daodalus
  class Configuration
    include Wendy
    include Singleton

    def self.load(file, env)
      instance.load(file, env)
    end

    def self.config
      instance.config
    end

    def config
      @config
    end

    def load(file, env)
      @config = wend(file).through(:read).and(:parse, env).result
    end

    private

    def read(file)
      File.new(file).read
    end

    def parse(file, env)
      YAML.load(file)[env.to_s]
    end

  end
end

