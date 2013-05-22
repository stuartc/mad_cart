module MadCart
  class Customer
    include MadCartModel

    required_attributes :first_name, :last_name, :email
  end
end
