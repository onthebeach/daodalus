module Daodalus
  module DSL
    class Transform
      include Chainable

      def initialize(operator, block, args)
        @operator = operator
        @block = block
        @args = args
      end

      def aggregate
        operator.aggregate.map do |result|
          block.call(result, *args)
        end
      end

      def find_one(options = {})
        result = operator.find_one(options)
        block.call(result, *args) if result
      end

      def find(options = {})
        operator.find(options).map do |result|
          block.call(result, *args)
        end
      end

      def find_and_modify(options = {})
        result = operator.find_and_modify(options)
        block.call(result, *args) if result
      end

      def dao
        operator.dao
      end

      private

      attr_reader :operator, :block, :args
    end
  end
end
