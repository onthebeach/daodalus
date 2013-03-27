module Daodalus
  module Model
    def initialize(data)
      @data = data
    end

    def data
      @data.has_key?(:_id) ? @data : @data.merge!(_id: BSON::ObjectId.new)
    end

    def self.included(base)
      base.extend(DocumentDescriptor)
    end

    module DocumentDescriptor

      def has_one(f, options={})
        define_method f do
          instance_variable_get(:"@#{f}") ||
            instance_variable_set(:"@#{f}", options.fetch(:type).new(data.fetch(f.to_s)))
        end
      end

      def has_many(f, options={})
        type = options.fetch(:type)
        define_method f do
          instance_variable_get(:"@#{f}") ||
            instance_variable_set(:"@#{f}", data.fetch(f.to_s).map {|x| type.new(x) } )
        end
      end

      def field(f, options={})
        key = options.fetch(:key, f)
        if options.has_key?(:default)
          define_field_with_default(f, key, options)
        else
          define_field(f, key)
        end
      end

      private

      def define_field(f, key)
        define_method f do
          data.fetch(key.to_s)
        end
      end

      def define_field_with_default(f, key, options)
        default = options.fetch(:default)
        default_proc = default.is_a?(Proc) ? default : lambda { default }
        define_method f do
          data.fetch(key.to_s, default_proc.call)
        end
      end

    end

  end
end
