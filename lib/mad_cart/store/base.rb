module MadCart
  module Store
    module Base

      def self.included(base)
        base.extend ClassMethods
        base.class_eval do
          include(InheritableAttributes)
          inheritable_attributes :connection_delegate, :required_connection_args, :fetch_delegates, :format_delegates, :after_init_delegate
        end
      end

      def connection
        @connection ||= execute_delegate(self.class.connection_delegate, {})
        return @connection
      end

      def execute_delegate(delegate, *args)
        return delegate.call(*args) if delegate.is_a?(Proc)
        return self.send(delegate, *args) if delegate.is_a?(Symbol)

        raise ArgumentError, "Invalid delegate" # if not returned by now
      end
      private :execute_delegate

      module ClassMethods
        def create_connection_with(*args)
          @connection_delegate = parse_delegate(args.first)
          @required_connection_args = args[1]

          raise ArgumentError, "Invalid delegate for create_connection_with: #{args.first.class}. Use Proc or Symbol." if @connection_delegate.nil?
        end

        def fetch(model, options={})
          @fetch_delegates ||= {}
          @format_delegates ||= {}
          @fetch_delegates[model] = parse_delegate(options)

          raise ArgumentError, "Invalid delegate for fetch: #{options.first.class}. Use Proc or Symbol." if @fetch_delegates[model].nil?

          define_method model do
            fetch_result = execute_delegate(self.class.fetch_delegates[model])
            self.class.format_delegates[model] ? fetch_result.map{|r| execute_delegate(self.class.format_delegates[model], r)} : fetch_result
          end
        end

        def format(model, options={})
          raise ArgumentError, "Cannot define 'format' for a model that has not defined 'fetch'" if @fetch_delegates[model].nil?

          @format_delegates[model] = parse_delegate(options)

          raise ArgumentError, "Invalid delegate for format: #{args.first.class}. Use Proc or Symbol." if @format_delegates[model].nil?
        end

        def after_initialize(*args)
        end

        def parse_delegate(arg)
          return arg if (arg.is_a?(Symbol) || arg.is_a?(Proc))
          return arg[:with] if arg.is_a?(Hash) && arg[:with]

          return nil # if no match
        end
        private :parse_delegate
      end
    end
  end
end
