# lib
require 'json'
require 'singleton'

# gems
require 'faraday'

# core
require 'mad_cart/configuration'

# data objects
require 'mad_cart/customer'
require 'mad_cart/product'

# stores
require 'mad_cart/store/big_commerce'
require 'mad_cart/store/etsy'


module MadCart
  class << self
    
    def configure
      raise(ArgumentError, "MadCart.configure requires a block argument.") unless block_given?
      yield(MadCart::Configuration.instance)
    end
    
    def config
      raise(ArgumentError, "MadCart.config does not support blocks. Use MadCart.configure to set config values.") if block_given?
      return MadCart::Configuration.instance.data
    end
    
  end
end


# Etsy.api_key = '4j3amz573gly866229iixzri'
# Etsy.environment = :production