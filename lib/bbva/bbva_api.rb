require 'logger'
require 'base64'
require 'rest-client'
require 'uri'

require 'bbva/bbva_resource_factory'
require 'errors/bbva_exception'

LOG= Logger.new(STDOUT)
#change to Logger::DEBUG if need trace information
#due the nature of the information, we recommend to never use a log file when in debug
LOG.level=Logger::FATAL

class BbvaApi
  #API Endpoints
  API_DEV='https://sand-api.ecommercebbva.com/v1/'
  API_PROD='https://api.ecommercebbva.com/v1/'

  #by default testing environment is used
  def initialize(merchant_id, private_key, production=false, timeout=90)
    @merchant_id=merchant_id
    @private_key=private_key
    @production=production
    @timeout=timeout
  end

  def create(resource)
    klass=BbvaResourceFactory::create(resource, @merchant_id, @private_key, @production, @timeout)
    klass.api_hook=self
    klass
  end

  def BbvaApi::base_url(production)
    if production
      API_PROD
    else
      API_DEV
    end
  end

  def env
    if @production
      :production
    else
      :test
    end
  end

end
