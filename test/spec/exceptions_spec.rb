require_relative '../spec_helper'

describe 'Bbva Exceptions' do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='***REMOVED***'
    
    #LOG.level=Logger::DEBUG

    @bbva=BbvaApi.new(@merchant_id, @private_key)
    @customers=@bbva.create(:customers)
    @cards=@bbva.create(:cards)

  end

  describe BbvaException do

    it 'should raise an BbvaException when a non given resource is passed to the api factory' do
     expect { @bbva.create(:foo) }.to raise_exception BbvaException
    end

    it 'should raise an BbvaException when the delete_all method is used on production' do
      @bbvaprod=BbvaApi.new(@merchant_id,@private_key,true)
      cust=@bbvaprod.create(:customers)
      expect { cust.delete_all }.to raise_exception BbvaException
    end

  end

  describe BbvaTransactionException do

    it 'should fail when an invalid field-value is passed in *email' do
      #invalid email format
      email='foo'
      customer_hash = FactoryBot.build(:customer, email: email)

      #perform checks
      expect { @customers.create(customer_hash) }.to raise_exception BbvaTransactionException
      begin
        @customers.create(customer_hash)
      rescue BbvaTransactionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 400
        expect(e.error_code).to be 1001
        #expect(e.description).to match 'not a well-formed email address'
        expect(e.json_body).to have_json_path('category')
      end
    end

    it ' raise  an BbvaTransactionException when trying to delete a non existing bank account '  do
      #non existing resource
      #perform checks
      expect { @customers.delete('1111') }.to raise_exception  BbvaTransactionException
      begin
        @customers.delete('1111')
      rescue BbvaTransactionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 404
        expect(e.error_code).to be 1005
        expect(e.description).to match "The customer with id '1111' does not exist"
        expect(e.json_body).to have_json_path('category')
      end
    end

    it 'raise  an BbvaTransactionException when using an expired card' do
      card_hash = FactoryBot.build(:expired_card)
      expect { @cards.create(card_hash) }.to raise_error(BbvaTransactionException)
      begin
        @cards.create(card_hash)
      rescue BbvaTransactionException => e
        expect(e.description).to match 'The card has expired'
        expect(e.error_code).to be 3002
      end

    end

  end

  describe BbvaConnectionException do

    it 'raise an BbvaConnectionException when provided credentials are invalid' do

      merchant_id='santa'
      private_key='invalid'

      bbva=BbvaApi.new(merchant_id, private_key)
      customers=bbva.create(:customers)
      expect { customers.delete('1111') }.to raise_exception  BbvaConnectionException

      begin
        customers.delete('1111')
      rescue BbvaConnectionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 401
        expect(e.error_code).to be 1002
        expect(e.description).to match 'The api key or merchant id are invalid'
        expect(e.json_body).to have_json_path('category')
      end

    end
  end

end
