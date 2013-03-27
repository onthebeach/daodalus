module Daodalus
  module Model
    def initialize(data)
      @data = data
    end

    attr_reader :data

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
          value = data.fetch(key.to_s)
          if type.nil? then value else apply_conversion(value, type) end
        end
      end

      def define_field_with_default(f, key, type, options)
        default = options.fetch(:default)
        default_proc = default.is_a?(Proc) ? default : lambda { default }
        define_method f do
          value = data.fetch(key.to_s, default_proc.call)
          if type.nil? then value else apply_conversion(value, type) end
        end
      end

    end

    private

    def apply_conversion(value, type)
      case type.to_s
      when 'Symbol' then value.to_sym
      else type.new(value)
      end
    end

  end
end
