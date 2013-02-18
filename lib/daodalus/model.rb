module Daodalus
  module Model
    def initialize(result)
      @result = result
    end

    def self.included(base)
      base.extend(DocumentDescriptor)
    end

    module DocumentDescriptor
      def field(f, options={})
        key = options.fetch(:key, f)
        type = options.fetch(:type, nil)
        if options.has_key?(:default)
          define_field_with_default(f, key, type, options)
        else
          define_field(f, key, type)
        end
      end

      private

      def define_field(f, key, type)
        define_method f do
          value = result.fetch(key.to_s)
          if type.nil? then value else apply_conversion(value, type) end
        end
      end

      def define_field_with_default(f, key, type, options)
        default = options.fetch(:default)
        define_method f do
          value = result.fetch(key.to_s, default)
          if type.nil? then value else apply_conversion(value, type) end
        end
      end

    end

    private

    attr_reader :result

    def apply_conversion(value, type)
      case type.to_s
      when 'Integer' then value.to_i
      when 'Float' then value.to_f
      when 'String' then value.to_s
      when 'Symbol' then value.to_sym
      when 'Date' then Date.parse(value)
      when 'Time' then Time.parse(value)
      else type.new(value)
      end
    end

  end
end
