require_relative '../spec_helper'

describe Tokens do
  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'

    #LOG.level=Logger::DEBUG

    @bbva=BbvaApi.new(@merchant_id, @private_key)
    @tokens=@bbva.create(:tokens)

  end

  describe '.create' do

    it 'creates a merchant token' do

      token_hash= FactoryBot.build(:token)
      token=@tokens.create(token_hash)

      #validates
      expect(@tokens.get(token['id']))

      #clean
      @tokens.delete(token['id'])

    end
  end

  describe 'get' do

    it 'gets a merchant token' do

      #creates a token
      token_hash= FactoryBot.build(:token)
      token=@tokens.create(token_hash)

      #validates
      expect(@tokens.get(token['id']))

      #clean
      @tokens.delete(token['id'])

    end
  end
end
