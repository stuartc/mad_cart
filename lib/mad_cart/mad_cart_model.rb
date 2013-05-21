module MadCart
  module MadCartModel
    include AttributeMapper

    def initialize(args={})
      args.each do |k,v|
        self.send("#{k}=", v) unless v.nil?
      end
    end
  end
end
