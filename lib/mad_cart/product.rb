module MadCart
  class Product
    include MadCartModel

     required_attributes :external_id, :name, :description, :price, :url, :currency_code, :image_url, :square_image_url
  end
end
