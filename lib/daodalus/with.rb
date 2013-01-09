module Daodalus
  module With

    def with(*args)
      dao.method(args.first).call(self, *args.drop(1))
    end

    def with_optional(clause, arg)
      if arg.nil?
        self
      else
        dao.method(clause).call(self, arg)
      end
    end

  end
end
