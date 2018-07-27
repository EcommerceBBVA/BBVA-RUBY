require 'bancomer_resource'

class Tokens < BancomerResource

  def create(token)
    super(token)
  end

  def get(token_id)
    super(token_id)
  end

end