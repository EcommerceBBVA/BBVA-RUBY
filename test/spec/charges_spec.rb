require_relative '../spec_helper'

describe Charges do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='***REMOVED***'

    @bbva = BbvaApi.new(@merchant_id, @private_key)
    @customers = @bbva.create(:customers)
    @tokens = @bbva.create(:tokens)


    #LOG.level=Logger::DEBUG

    @charges=@bbva.create(:charges)

  end

  it 'has all required methods' do
    %w(all each create get list delete).each do |meth|
      expect(@charges).to respond_to(meth)
    end
  end

  describe '.create' do

    it 'creates a new merchant charge using token' do
      #create new customer
      customer_hash= FactoryBot.build(:customer)
      customer=@customers.create(customer_hash)

      #create token
      token_hash=FactoryBot.build(:token_charge)
      token=@tokens.create(token_hash)

      #create charge attached to prev created token
      charge_hash=FactoryBot.build(:token_charge, token: token['id'])
      charge=@charges.create(charge_hash)

      #perform check
      stored_charge=@charges.get(charge['id'])
      expect(stored_charge['amount']).to be_within(0.1).of(11)

      #clean up
      @customers.delete(customer['id'])

    end

  end

  describe '.capture' do

    it 'captures a merchant card charge'  do

      #create new customer
      customer_hash = FactoryBot.build(:customer)
      customer = @customers.create(customer_hash)

      #create token
      token_hash = FactoryBot.build(:token_charge)
      token = @tokens.create(token_hash)

      #create charge attached to prev created token
      charge_hash = FactoryBot.build(:token_charge, token: token['id'], capture: 'FALSE')
      charge=@charges.create(charge_hash)

      #capture merchant charge
      @charges.capture(charge['id'])

      #clean up
      @customers.delete(customer['id'])

    end

  end

  describe '.confirm_capture' do

    it 'confirms a capture on a merchant charge' do

      #create new customer
      customer_hash = FactoryBot.build(:customer)
      customer = @customers.create(customer_hash)

      #create token
      token_hash = FactoryBot.build(:token_charge)
      token = @tokens.create(token_hash)

      #create charge attached to prev created token
      charge_hash = FactoryBot.build(:token_charge, token: token['id'], capture: 'FALSE', amount: 100)
      charge=@charges.create(charge_hash)

      confirm_capture_options = {  transaction_id: charge['id'], amount: 100  }

      #confirm capture
      res = @charges.confirm_capture(confirm_capture_options)
      expect(res['amount']).to eq 100

      #clean up
      @customers.delete(customer['id'])

    end

  end

  describe '.refund' do

    #Refunds apply only for card charges
    it 'refunds  an existing merchant charge' do
      #create new customer
      customer_hash = FactoryBot.build(:customer)
      customer = @customers.create(customer_hash)

      #create token
      token_hash = FactoryBot.build(:token_charge)
      token = @tokens.create(token_hash)

      #create charge attached to prev created token
      charge_hash = FactoryBot.build(:token_charge, token: token['id'], capture: 'TRUE', amount: 500)
      charge=@charges.create(charge_hash)

      #creates refund_description
      refund_description=FactoryBot.build(:refund_description)
      expect(@charges.get(charge['id'])['refund']).to be nil

      @charges.refund(charge['id'],refund_description)
      expect(@charges.get(charge['id'])['refund']['amount'] ).to be_within(0.1).of(505)

      #clean up
      @customers.delete(customer['id'])
    end

  end

end
