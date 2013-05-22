require "spec_helper"

describe "configuration" do

  # use a clean instance for each test
  before(:each) do
    clear_config
  end

  describe "stores" do

    it "does not require store to be added if credentials are passed to constructor" do
      lambda{ MadCart::Store::BigCommerce.new({:api_key => 'a_fake_key', :store_url => '/path/to/store', :username => 'bob'}) }.should_not raise_error
    end

    it "allows config values to be set for a store" do
      config_data = {:arbitrary => 'data'}
      MadCart.configure do |config|
        config.add_store :big_commerce, config_data
      end

      MadCart.config.big_commerce.should == config_data
    end

    it "gives feedback about missing store configs" do
      error_message = "Undefinied config: missing_store. Add a store by calling #add_store on the configuration object in the MadCart.configure block argument."

      lambda do
        MadCart.config.missing_store
      end.should raise_error(MadCart::Configuration::Data::ConfigurationError, error_message)
    end

  end

  describe "models" do
    it "allows custom attribute names to be set" do
      lambda {
        MadCart.configure do |config|
          config.attribute_map :product, {"name" => "title"}
        end
      }.should_not raise_error

      MadCart.config.attribute_maps["product"].should == {"name" => "title"}
    end

  end

end
