require_relative '../spec_helper'

describe 'Bancomer Exceptions' do

  before(:all) do

    @merchant_id='mywvupjjs9xdnryxtplq'
    @private_key='sk_92b25d3baec149e6b428d81abfe37006'
    
    #LOG.level=Logger::DEBUG

    @bancomer=BancomerApi.new(@merchant_id, @private_key)
    @customers=@bancomer.create(:customers)
    @cards=@bancomer.create(:cards)

  end

  describe BancomerException do

    it 'should raise an BancomerException when a non given resource is passed to the api factory' do
     expect { @bancomer.create(:foo) }.to raise_exception BancomerException
    end

    it 'should raise an BancomerException when the delete_all method is used on production' do
      @bancomerprod=BancomerApi.new(@merchant_id,@private_key,true)
      cust=@bancomerprod.create(:customers)
      expect { cust.delete_all }.to raise_exception BancomerException
    end

  end

  describe BancomerTransactionException do

    it 'should fail when an invalid field-value is passed in *email' do
      #invalid email format
      email='foo'
      customer_hash = FactoryBot.build(:customer, email: email)

      #perform checks
      expect { @customers.create(customer_hash) }.to raise_exception BancomerTransactionException
      begin
        @customers.create(customer_hash)
      rescue BancomerTransactionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 400
        expect(e.error_code).to be 1001
        #expect(e.description).to match 'not a well-formed email address'
        expect(e.json_body).to have_json_path('category')
      end
    end

    it ' raise  an BancomerTransactionException when trying to delete a non existing bank account '  do
      #non existing resource
      #perform checks
      expect { @customers.delete('1111') }.to raise_exception  BancomerTransactionException
      begin
        @customers.delete('1111')
      rescue BancomerTransactionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 404
        expect(e.error_code).to be 1005
        expect(e.description).to match "The customer with id '1111' does not exist"
        expect(e.json_body).to have_json_path('category')
      end
    end

    it 'raise  an BancomerTransactionException when using an expired card' do
      card_hash = FactoryBot.build(:expired_card)
      expect { @cards.create(card_hash) }.to raise_error(BancomerTransactionException)
      begin
        @cards.create(card_hash)
      rescue BancomerTransactionException => e
        expect(e.description).to match 'The card has expired'
        expect(e.error_code).to be 3002
      end

    end

  end

  describe BancomerConnectionException do

    it 'raise an BancomerConnectionException when provided credentials are invalid' do

      merchant_id='santa'
      private_key='invalid'

      bancomer=BancomerApi.new(merchant_id, private_key)
      customers=bancomer.create(:customers)
      expect { customers.delete('1111') }.to raise_exception  BancomerConnectionException

      begin
        customers.delete('1111')
      rescue BancomerConnectionException => e
        #should have the corresponding attributes coming from the json message
        expect(e.http_code).to be 401
        expect(e.error_code).to be 1002
        expect(e.description).to match 'The api key or merchant id are invalid'
        expect(e.json_body).to have_json_path('category')
      end

    end
  end

end
