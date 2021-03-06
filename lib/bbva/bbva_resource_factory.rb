class BbvaResourceFactory
  def BbvaResourceFactory::create(resource,merchant_id,private_key,production,timeout)
    begin
      Object.const_get(resource.capitalize).new(merchant_id,private_key,production,timeout)
    rescue NameError
      raise BbvaException.new("Invalid resource name:#{resource}",false)
    end
  end
end

