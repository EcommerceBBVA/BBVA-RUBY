#bancomer version
require 'version'

#external dependencies
require 'rest-client'
require 'json'

module Bancomer

  #api setup / constants
  require 'bancomer/bancomer_api'

  #base class
  require 'bancomer/bancomer_resource'

  #resource classes
  require 'bancomer/charges'
  require 'bancomer/customers'
  require 'bancomer/tokens'

  #misc
  require 'bancomer/utils/search_params'

  #exceptions
  require 'errors/bancomer_exception_factory'
  require 'errors/bancomer_exception'
  require 'errors/bancomer_transaction_exception'
  require 'errors/bancomer_connection_exception'

  include BancomerUtils
end
