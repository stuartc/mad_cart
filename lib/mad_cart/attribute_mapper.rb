module MadCart
  module AttributeMapper

    def attributes
      Hash[initial_attributes.map {|k, v| [(mapping_hash[k] || mapping_hash[k.to_sym] || k).to_s, v] }]
    end

    def mapping_hash
      MadCart.config.attribute_maps[self.class.to_s.split('::').last.underscore] || {}
    end

    def initial_attributes
      Hash[self.class.required_attrs.map{|a| [a.to_s, self.send(a)]}]
    end

  end
end
