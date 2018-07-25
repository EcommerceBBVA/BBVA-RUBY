require 'bancomer_resource'

class Tokens < BancomerResource

  def create(token)
    super(token)
  end

  def get(token_id)
    get("/tokens/#{token_id}")
  end

end