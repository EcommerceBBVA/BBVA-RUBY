require_relative '../spec_helper'


describe 'Request timeout exception' do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='***REMOVED***'
    
    #LOG.level=Logger::DEBUG

    @bancomer=BancomerApi.new(@merchant_id, @private_key, false, 0)
    @charges=@bancomer.create(:charges)

  end

  it 'raise an BancomerConnectionException when the operation timeouts' do
    expect{@charges.all}.to raise_error(BancomerConnectionException)
  end

end
