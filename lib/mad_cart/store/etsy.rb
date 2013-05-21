require 'etsy'
require 'money'

module MadCart
  module Store
    class Etsy
      DEFAULT_ETSY_LIMIT = 25

      attr_accessor :store_name
      attr_reader :shop

      def initialize(args={})
        self.store_name = args.delete(:store_name)
        create_connection(args)
      end

      def products
        return get_product_hashes.map{|ph| MadCart::Product.new(ph) }
      end

      private

      def get_product_hashes
        self.shop.listings(:active, {:includes => 'Images'}).map {|listing|
            {
             :external_id => listing.id,
             :name => listing.title,
             :description => listing.description,
             :price => "#{listing.price} #{listing.currency}".to_money.format,
             :url => listing.url,
             :currency_code => listing.currency,
             :image_url => listing.image.full,
             :square_image_url => listing.image.square
          }
        }
      end

      def create_connection(args)
        ::Etsy.api_key = get_api_key(args) if !::Etsy.api_key || (::Etsy.api_key != get_api_key(args))
        ::Etsy.environment = :production
        @shop = ::Etsy::Shop.find(self.store_name).first
      end

      def get_api_key(args)
        args[:api_key] || MadCart.config.etsy[:api_key]
      end

    end
  end
end

