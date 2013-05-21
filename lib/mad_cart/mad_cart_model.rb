module MadCart
  module MadCartModel
    include AttributeMapper
    
    attr_accessor :additional_attributes

    def initialize(args={})
      self.additional_attributes = {}
      
      args.each do |k,v|
        if self.class::ATTRIBUTES.include? k
          self.send("#{k}=", v) unless v.nil?
        else
          self.additional_attributes[k] = v unless v.nil?
        end
      end
    end
    
  end
end
