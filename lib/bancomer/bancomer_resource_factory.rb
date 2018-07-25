class BancomerResourceFactory
  def BancomerResourceFactory::create(resource,merchant_id,private_key,production,timeout)
    begin
      Object.const_get(resource.capitalize).new(merchant_id,private_key,production,timeout)
    rescue NameError
      raise BancomerException.new("Invalid resource name:#{resource}",false)
    end
  end
end

