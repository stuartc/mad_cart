module MadCart
  module MadCartModel
    attr_accessor :additional_attributes

    def initialize(args={})
      self.additional_attributes = {}

      self.class.attributes.each do |attr|
        raise(ArgumentError, "missing argument: #{attr}") if !args.keys.map{|a| a.to_s }.include? attr
      end

      args.each do |k,v|
        if self.class.attributes.include? k.to_s
          self.send("#{k}=", v) unless v.nil?
        else
          self.additional_attributes[k.to_s] = v unless v.nil?
        end
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
      base.class_eval do
        include(AttributeMapper)
        include(InheritableAttributes)
        attr_accessor :additional_attributes
        inheritable_attributes :attributes
      end
    end

    module ClassMethods
      def required_attributes(*args)
        @attributes = args.map{|a| a.to_s }
        args.each{|a| attr_accessor(a) }
      end
    end

  end
end
