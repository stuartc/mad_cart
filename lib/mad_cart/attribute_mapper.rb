module MadCart
  module AttributeMapper

    def attributes
      Hash[initial_attributes.map {|k, v| [mapping_hash[k] || k, v] }]
    end

    def mapping_hash
      MadCart.config.attribute_maps[self.class.to_s.split('::').last.underscore.to_sym] || {}
    end

    def initial_attributes
      Hash[self.class::ATTRIBUTES.map{|a| [a, self.send(a)]}]
    end

  end
end
