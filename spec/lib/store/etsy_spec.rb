require "spec_helper"

describe MadCart::Store::Etsy do

  before(:each) do
    clear_config
    MadCart.configure do |config|
      config.add_store :etsy, {:api_key => 'a_made_up_key'}
    end
  end

  describe "products" do

    it "returns products" do
      VCR.use_cassette('etsy_store_listings') do
        api = MadCart::Store::Etsy.new()
        api.products.size.should == 1

        first_product = api.products.first

        first_product.should be_a(MadCart::Product)
        first_product.name.should_not be_nil
        first_product.price.should_not be_nil
        first_product.external_id.should_not be_nil
        first_product.description.should_not be_nil
        first_product.url.should_not be_nil
        first_product.currency_code.should_not be_nil
        first_product.image_url.should_not be_nil
        first_product.square_image_url.should_not be_nil
      end
    end

  end

end
