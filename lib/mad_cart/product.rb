module MadCart
  class Product
    include MadCartModel
    
    ATTRIBUTES = [:external_id, :name, :description, :price, :url, :currency_code, :image_url, :square_image_url]
    ATTRIBUTES.each {|attr| attr_accessor(attr) }
  end
end
