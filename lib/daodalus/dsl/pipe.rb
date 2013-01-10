module Daodalus
  module DSL
    class Pipe
      include Chainable

      def initialize(operator, block)
        @operator = operator
        @block = block
      end

      def aggregate
        block.call(operator.aggregate)
      end

      def find_one(options = {})
        result = operator.find_one(options)
        block.call(result) if result
      end

      def find(options = {})
        block.call(operator.find(options))
      end

      def find_and_modify(options = {})
        result = operator.find_and_modify(options)
        block.call(result) if result
      end

      def dao
        operator.dao
      end

      private

      attr_reader :operator, :block
    end
  end
end

