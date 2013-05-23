require "spec_helper"

describe MadCart::Store::Base do
  before(:each) do
    class MyStore; include MadCart::Store::Base; end
    Object.send(:remove_const, :TestResult) if Object.const_defined?(:TestResult)
    class TestResult; end
  end

  describe "connection" do
    it "adds a create_connection_with method" do
      MyStore.should respond_to(:create_connection_with)
    end

    it "accepts a method reference" do
      MyStore.class_eval do
        create_connection_with :connection_method

        def connection_method(args={})
          return TestResult
        end
      end

      MyStore.new.connection.should == TestResult
    end

    it "accepts a proc" do
      MyStore.class_eval do
        create_connection_with Proc.new {|args| TestResult }
      end

      MyStore.new.connection.should == TestResult
    end
  end

  describe "fetch" do
    it "adds a fetch method" do
      MyStore.should respond_to(:fetch)
    end

    it "accepts a method reference" do
      MyStore.class_eval do
        fetch :products, :with => :fetch_method

        def fetch_method
          return [TestResult, TestResult]
        end
      end

      MyStore.new.products.should == [TestResult, TestResult]
    end

    it "accepts a proc" do
      MyStore.class_eval do
        fetch :products, :with => Proc.new { [TestResult, TestResult] }
      end

      MyStore.new.products.should == [TestResult, TestResult]
    end
  end

  describe "format" do
    it "adds a format method" do
      MyStore.should respond_to(:format)
    end

    it "accepts a method reference" do
      MyStore.class_eval do
        fetch :products, :with => Proc.new { [TestResult, TestResult] }
        format :products, :with => :format_method

        def format_method(product)
          return product.to_s
        end
      end

      MyStore.new.products.should == ["TestResult", "TestResult"]
    end

    it "accepts a proc" do
      MyStore.class_eval do
        fetch :products, :with => Proc.new { [TestResult, TestResult] }
        format :products, :with => Proc.new {|product| product.to_s }
      end

      MyStore.new.products.should == ["TestResult", "TestResult"]
    end
  end

  describe "initialize" do
    it "retrieves configured connection arguments"
  end

  describe "after_initialize" do
    it "adds an after_initialize method" do
      MyStore.should respond_to(:after_initialize)
    end
  end
end
