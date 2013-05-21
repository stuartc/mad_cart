require 'ostruct'

module MadCart
  class Configuration
    include Singleton
    
    def add_store(store_name, args={})
      @data ||= {:stores => []}
      
      @data[:stores] << store_name
      @data[store_name.to_sym] = args
    end
    
    def data
      Data.new(@data)
    end    
    
    class Data < OpenStruct
      class ConfigurationError < NoMethodError; end

      def method_missing(meth)
        raise(ConfigurationError, "Undefinied config: #{meth}. Add a store by calling #add_store on the configuration object in the MadCart.configure block argument.")
      end

    end
  end
end