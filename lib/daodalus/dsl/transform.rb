module Daodalus
  module DSL
    class Transform

      def initialize(operator, block)
        @operator = operator
        @block = block
      end

      def aggregate
        operator.aggregate.map(&block)
      end

      def find_one(options = {})
        result = operator.find_one(options)
        block.call(result) if result
      end

      def find(options = {})
        operator.find(options).map(&block)
      end

      def find_and_modify(options = {})
        result = operator.find_and_modify(options)
        block.call(result) if result
      end

      def transform(&block)
        Transform.new(self, block)
      end

      private

      attr_reader :operator, :block
    end
  end
end
