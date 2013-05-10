require "spec_helper"

describe MadCart::Store::BigCommerce do
  
  describe "store" do
    
    it "expects to be instantiated with an api key, username and store url" do
      lambda { MadCart::Store::BigCommerce.new(:api_key => 'test', :username => 'test',) }.should raise_error(ArgumentError)
      lambda { MadCart::Store::BigCommerce.new(:api_key => 'test', :store_url => 'test') }.should raise_error(ArgumentError)
      lambda { MadCart::Store::BigCommerce.new(:username => 'test', :store_url => 'test') }.should raise_error(ArgumentError)
      lambda { MadCart::Store::BigCommerce.new(:api_key => 'test', :username => 'test', :store_url => 'test') }.should_not raise_error
    end
    
  end
  
  describe "customers" do
    context "retrieval" do

      it "returns all customers" do
        VCR.use_cassette('big_commerce', :record => :new_episodes) do
          api = MadCart::Store::BigCommerce.new(
            :api_key => '0ff0e3939f5f160f36047cf0caa6f699fe24bdeb', 
            :store_url => 'store-cr4wsh4.mybigcommerce.com', 
            :username => 'admin'
          ) 
    
          api.customers.size.should be > 0
          api.customers.first.should be_a(MadCart::Customer)
        end
      end
      
      it "returns an empty array whern there are no customers" do
        VCR.use_cassette('big_commerce_no_records') do
          api = MadCart::Store::BigCommerce.new(
            :api_key => '0ff0e3939f5f160f36047cf0caa6f699fe24bdeb', 
            :store_url => 'store-cr4wsh4.mybigcommerce.com', 
            :username => 'admin'
          ) 
    
          api.customers.should eql([])
        end
      end

    end
  end
  
end

 
# 
#   test "#loop will iterate over all available resources" do
# 
#       api = BigCommerce::API.new(
#         :api_key => '0ff0e3939f5f160f36047cf0caa6f699fe24bdeb', 
#         :store_url => 'store-cr4wsh4.mybigcommerce.com', 
#         :username => 'admin'
#       ) 
# 
#       set_one = (1..200).to_a.map { |x| {:id => x} }
#       set_two = (1..35).to_a.map { |x| {:id => x} }
#       set_one.stubs(:max_id).returns(200)
#       set_two.stubs(:max_id).returns(35)
#       api.expects(:customers).with(:min_id => 1).returns(set_one)
#       api.expects(:customers).with(:min_id => 201).returns(set_two)
# 
#       count = 0
#       api.loop(:customers) { |customer| count += 1 }
#       assert_equal 235, count
# 
#   end
#   
# 
# end
