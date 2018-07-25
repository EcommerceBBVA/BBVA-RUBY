require_relative '../spec_helper'

describe 'BancomerResource' do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='***REMOVED***'

    #LOG.level=Logger::DEBUG

    @bancomer=BancomerApi.new(@merchant_id,@private_key)
    @cards=@bancomer.create(:cards)

  end

  describe '.hash2json' do

    it 'converts a ruby hash into a json string' do
      card_hash = FactoryBot.build(:valid_card, holder_name: 'Juan')
      json=@cards.hash2json(card_hash)
      expect(json).to have_json_path('holder_name')
      expect(json).to have_json_path('expiration_year')
      expect(json).to have_json_path('bank_code')

    end

  end


  describe '.json2hash' do

    it 'converts json into a ruby hash' do
      card_hash = FactoryBot.build(:valid_card, holder_name: 'Pepe')
      json=@cards.hash2json(card_hash)
      jash=@cards.json2hash(json)
      expect(jash).to be_a Hash
      expect(jash['holder_name']).to match 'Pepe'

    end

  end

end