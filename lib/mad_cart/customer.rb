module MadCart
  class Customer
    
    def initialize(args={})
      ["first_name", "last_name", "email"].each do |key|
        raise(ArgumentError, "MadCart::Customer - Missing argument: #{key}") unless args.include? key
      end
    end
    
  end
end