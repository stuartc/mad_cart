require "spec_helper"

describe MadCart::Customer do

  before(:each) do
    clear_config
  end

  it "returns the default attributes" do
    attrs = {:first_name => 'Bob', :last_name => 'Sagat', :email => 'bob@sagat.com'}
    c = MadCart::Customer.new(attrs)

    c.attributes.should eql(attrs)
  end

  it "allows attributes to be overwritten" do
    MadCart.configure do |config|
      config.attribute_map :customer, {:first_name => :name}
    end

    c = MadCart::Customer.new(:first_name => 'Bob', :last_name => 'Sagat', :email => 'bob@sagat.com')

    c.attributes.should eql({:name => 'Bob', :last_name => 'Sagat', :email => 'bob@sagat.com'})
  end
  
  it "exposes all additional attributes provided by the api" do
    c = MadCart::Customer.new(:first_name => 'Bob', :last_name => 'Sagat', :email => 'bob@sagat.com', :with => 'some', :additional => 'fields' )

    c.additional_attributes.should eql({:with => 'some', :additional => 'fields'})
  end

end
