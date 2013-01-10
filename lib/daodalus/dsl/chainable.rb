module Daodalus
  module DSL
    module Chainable

      def with(*args)
        dao.method(args.first).call(self, *args.drop(1))
      end

      def pipe(f=nil, &block)
        Pipe.new(self, f.nil? ? block : dao.method(f))
      end

      def transform(f=nil, &block)
        Transform.new(self, f.nil? ? block : dao.method(f))
      end

      def extract(key)
        transform {|result| result.fetch(key.to_s) }
      end

    end
  end
end
