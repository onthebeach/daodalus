# DAODALUS

[![Build Status](https://travis-ci.org/onthebeach/daodalus.png?branch=master)](https://travis-ci.org/onthebeach/daodalus)

### Construct complex MongoDB queries, updates and aggregations.

### Configuration:

    # config/mongo.yml
    development:
      animals:
        database: animals_development
        host: localhost
        pool_size: 5
        timeout: 5
        replicate_set_name: animals_development
        servers:
          - { host: localhost, port: 27017 }

### Initialisation:

    # config/initializers/daodalus.rb
    Daodalus::Configuration.load('config/mongo.yml', Rails.env)

##### Examples:

    #!ruby
    class CatDAO
      extend Daodalus::DAO # or `include` if you want an instance of a DAO
      target :animals, :cats # or overide `connection` to supply your own

      def self.example_find
        select(:name).where(:paws).less_than(4).find
      end

      def self.example_find_one
        where(:collar_id).eq("aochc986").find_one
      end

      def self.example_update
        set(:stray, true).where(:address).does_not_exist.update
      end

      def self.example_find_and_modify
        dec(:lives).
          push(:names, "Kitty").
          where(:stray).eq(true).
          and(:cuteness).gt(8).
          find_and_modify(new: true)
      end

      def self.example_remove
        where(:lives).eq(0).remove
      end

      def self.example_aggregation
        match(:lives).gt(3).
          and(:address).exists.
          unwind(:favourite_foods).
          group(:favourite_foods).
          min(min_paws: 'paws').
          sort(:_id).
          limit(10).
          project(:_id).as(:food).and(:min_paws).
          aggregate
      end
    end
