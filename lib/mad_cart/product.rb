module MadCart
  class Product
    attr_accessor :external_id, :name, :description, :price, :url, :currency_code, :image_url, :square_image_url

    def initialize(args={})
      args.each do |k,v|
        instance_variable_set("@#{k}", v) unless v.nil?
      end
    end
  end
end
