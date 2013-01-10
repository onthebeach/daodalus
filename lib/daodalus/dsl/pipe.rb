module Daodalus
  module DSL
    class Pipe
      include Chainable

      def initialize(operator, block, args)
        @operator = operator
        @block = block
        @args = args
      end

      def aggregate
        block.call(operator.aggregate, *args)
      end

      def find_one(options = {})
        result = operator.find_one(options)
        block.call(result, *args) if result
      end

      def find(options = {})
        block.call(operator.find(options), *args)
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

