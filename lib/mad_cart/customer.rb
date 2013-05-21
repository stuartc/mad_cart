module MadCart
  class Customer
    include MadCartModel

    ATTRIBUTES = [:first_name, :last_name, :email]
    ATTRIBUTES.each {|attr| attr_accessor(attr) }
  end
end
