#bbva version
require 'version'

#external dependencies
require 'rest-client'
require 'json'

module Bbva

  #api setup / constants
  require 'bbva/bbva_api'

  #base class
  require 'bbva/bbva_resource'

  #resource classes
  require 'bbva/charges'
  require 'bbva/customers'
  require 'bbva/tokens'

  #misc
  require 'bbva/utils/search_params'

  #exceptions
  require 'bbva/errors/bbva_exception_factory'
  require 'bbva/errors/bbva_exception'
  require 'bbva/errors/bbva_transaction_exception'
  require 'bbva/errors/bbva_connection_exception'

  include BbvaUtils
end
