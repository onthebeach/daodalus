module Daodalus
  module DSL
    module Chainable

      def with(*args)
        dao.method(args.first).call(self, *args.drop(1))
      end

      def pipe(f=nil, *args, &block)
        Pipe.new(self, f.nil? ? block : dao.method(f), args)
      end

      def transform(f=nil, *args, &block)
        Transform.new(self, f.nil? ? block : dao.method(f), args)
      end

      def extract(key)
        transform {|result| result.fetch(key.to_s) }
      end

      def map_to(result_class)
        transform {|result| result_class.new(result) }
      end

    end
  end
end
