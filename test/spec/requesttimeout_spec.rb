require_relative '../spec_helper'


describe 'Request timeout exception' do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_xxxxxxxxxxxxxxxxxxxxxxx'
    
    #LOG.level=Logger::DEBUG

    @bbva=BbvaApi.new(@merchant_id, @private_key, false, 0)
    @charges=@bbva.create(:charges)

  end

  it 'raise an BbvaConnectionException when the operation timeouts' do
    expect{@charges.all}.to raise_error(BbvaConnectionException)
  end

end
