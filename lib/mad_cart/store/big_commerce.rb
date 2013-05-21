module MadCart
  module Store
    class BigCommerce

      class InvalidStore < StandardError; end;
      class ServerError < StandardError; end;
      class InvalidCredentials < StandardError; end;

      attr_reader :connection, :api_key, :store_url, :username

      def initialize(args)
        create_connection(args)
      end

      def customers
        return get_customer_hashes.map{|ch| MadCart::Customer.new(ch) }
      end

      private

      def make_customer_request(params={:min_id => 1})
        parse_response { connection.get('customers.json', params) }
      end

      def get_customer_hashes
        result = []
        loop(:make_customer_request) {|c| result << c }
        return result
      end

      def loop(source, &block)

        items = send(source, :min_id => 1)

        while true
          items.each &block
          break if items.count < 200
          items = send(source, :min_id => items.max_id + 1 )
        end

      end

      def parse_response(&block)
        response = check_for_errors &block
        return [] if empty_body?(response)
        return JSON.parse(response.body)
      end

      def check_for_errors(&block)
        response = yield

        case response.status
        when 401
          raise InvalidCredentials
        when 500
          raise ServerError
        end

        response
      rescue Faraday::Error::ConnectionFailed => e
        raise InvalidStore
      end

      def api_url_for(store_domain)
       "https://#{store_domain}/api/v2/"
      end

      def empty_body?(response)
        true if response.status == 204 || response.body.nil?
      end

      def create_connection(args={})
        validate_connection_args(args)

        @connection = Faraday.new(:url => api_url_for(args[:store_url]))
        @connection.basic_auth(args[:username], args[:api_key])
      end

      def validate_connection_args(args={})
        [:api_key, :store_url, :username].each do |key|
          raise ArgumentError if !args.include? key
          instance_variable_set("@#{key}".to_sym, args[key])
        end
      end
    end
  end
end
