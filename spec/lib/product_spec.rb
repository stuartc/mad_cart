require "spec_helper"

describe MadCart::Product do

  before(:each) do
    clear_config
  end

  it "returns the default attributes" do
    attrs = {:external_id => 'id', :name => 'product name', :description => 'product description', :price => '12USD',
             :url => 'path/to/product', :currency_code => 'ZAR',
             :image_url => 'path/to/image', :square_image_url => 'path/to/square/image'}
             
    c = MadCart::Product.new(attrs)

    c.attributes.should eql(attrs)
  end

  it "allows attributes to be overwritten" do
    MadCart.configure do |config|
      config.attribute_map :product, {:square_image_url => :thumbnail}
    end
    
    attrs = {:external_id => 'id', :name => 'product name', :description => 'product description', :price => '12USD',
             :url => 'path/to/product', :currency_code => 'ZAR',
             :image_url => 'path/to/image'}

    c = MadCart::Product.new(attrs.merge(:square_image_url => 'path/to/square/image'))

    c.attributes.should eql(attrs.merge(:thumbnail => 'path/to/square/image'))
  end
  
  it "exposes all additional attributes provided by the api" do
    attrs = {:external_id => 'id', :name => 'product name', :description => 'product description', :price => '12USD',
             :url => 'path/to/product', :currency_code => 'ZAR',
             :image_url => 'path/to/image', :square_image_url => 'path/to/square/image'}
             
    c = MadCart::Product.new(attrs.merge(:with => 'some', :additional => 'fields'))

    c.additional_attributes.should eql({:with => 'some', :additional => 'fields'})
  end

end
