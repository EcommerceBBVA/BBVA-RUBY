![Bbva Ruby]()

[![Build Status]()]()

[![Gem Version]()]()

## Description

ruby client for *Bbva api* services (version 1.0)

This is a ruby client implementing the payment services for *Bbva* at bbva.mx

For more information about Bbva visit:
 - http://bbva.mx/

For the full *Bbva api* documentation take a look at:
 - https://docs.ecommercebbva.com

## Installation

   Add the following line to your Gem file

    #bbva gem
     gem 'bbva'

Update your bundle:

    $ bundle

Or install it from the command line:

    $ gem install bbva

### Requirements

    * ruby 2.4 or higher

## Usage


### Initialization
```ruby
require 'bbva'


#merchant and private key
merchant_id='mywvupjjs9xdnryxtplq'
private_key='***REMOVED***'


#An bbva resource factory instance is created out of the BbvaApi
#it  points to the development environment  by default.
bbva=BbvaApi.new(merchant_id,private_key)

#To enable production mode you should pass a third argument as true.
#bbva_prod=BbvaApi.new(merchant_id,private_key,true)

#This ruby client manages a default timeout of 90 seconds to make the request 
#    to Bbva services, if you need to modify this value, you need to explicitly 
#    define the type of environment and followed by the new value for the timeout.
#Syntax:
#   bbva_prod=BbvaApi.new(merchant_id,private_key,isProduction,timeout)
#Example:
#   bbva_prod=BbvaApi.new(merchant_id,private_key,false,30)
 ```

The bbva factory instance is in charge to generate the required resources through a factory method (create).
Resource classes should be initialized using the factory method as described below.

 ```ruby
#creating an instance for each available resource
@charges = bbva.create(:charges)
@tokens = bbva.create(:tokens)
```

According to the current version of the *Bbva api* the available resources are:

- *charges*
- *tokens*

Each rest resource exposed in the rest *Bbva api* is represented by a class in this ruby API, being **BbvaResource** the base class.


### Implementation
 Each resource depending of its structure and available methods, will have one or more of the methods described under the methods subsection.
 Below a short description about the implementation high level details. For detailed documentation take a look a the bbva api documentation.


#### Arguments
Given most resources belong, either to a merchant or a customer, the api was designed taking this in consideration, so:

The first argument represent the json/hash object, while the second argument which is optional represents the **customer_id**.
So if  just one argument is provided the action will be performed at the merchant level,
but if the second argument is provided passing the **customer_id**, the action will be performed at the customer level.


The following illustrates the api design.

 ```ruby
#Merchant
hash_out=bbva_resource.create(hash_in)
json_out=bbva_resource.create(json_in)


#Customer
hash_out=bbva_resource.create(hash_in,customer_id)
json_out=bbva_resource.create(json_in,customer_id)

 ```

####  Methods Inputs/Outputs

This api supports both ruby hashes and json strings as inputs and outputs. (See previous example)
If a ruby hash is passed in as in input, a hash will be returned as the method output.
if a json string is passed in as an input, a json string will be returned as the method function output.

This code excerpt from a specification demonstrates how you can use hashes and json strings  interchangeably.

Methods without inputs will return a ruby hash.

```ruby
it 'creates a fee using a json message' do
  #create token, using factory girl to build the hash for us
  token_hash=FactoryBot.build(:token)
  token=@tokens.create(token_hash)

  #create charge
  charge_hash=FactoryBot.build(:card_charge, token: token['id'], amount: 4000)
  charge=@charges.create(charge_hash)
end
```

Here you can see how the **token_hash** representation looks like.

```ruby
require 'pp'
pp token_hash   =>

{:holder_name=>"Vicente Olmos",
:expiration_month=>"09",
:card_number=>"4111111111111111",
:expiration_year=>"14",
:cvv2=>"111",
:address=>
{:postal_code=>"76190",
:state=>"QRO",
:line1=>"LINE1",
:line2=>"LINE2",
:line3=>"LINE3",
:country_code=>"MX",
:city=>"Queretaro"}}
```

Next, how we construct  the preceding hash using **FactoryBot**.
**FactoryBot** was used in our test suite to facilitate hash construction.
It  may help you  as well at your final implementation if you decide to use hashes.
(more examples at *test/Factories.rb*)

```ruby

FactoryBot.define do
  factory :token, class:Hash do
        holder_name 'Vicente Olmos'
        expiration_month '09'
        card_number '4111111111111111'
        expiration_year '14'
        cvv2  '111'
       address {{
           postal_code: '76190',
           state: 'QRO',
           line1: 'LINE1',
           line2: 'LINE2',
           line3: 'LINE3',
           country_code: 'MX',
           city: 'Queretaro',
       }}
    initialize_with { attributes }
  end
```

### Methods design

This ruby API standardize the method names across all different resources using the **create**,**get**,**update** and **delete** verbs.

For full method documentation take a look at:
  - https://docs.ecommercebbva.com

The test suite at *test/spec* is a good source of reference.

##### create

   Creates the given resource
 ```ruby
     bbva_resource.create(representation,customer_id=nil)
 ```

##### get

   Gets an instance of a  given resource

```ruby
bbva_resource.get(object_id,customer_id=nil)
```

##### update

   Updates an instance of a given resource

```ruby
bbva_resource.update(representation,customer_id=nil)
```

##### delete

  Deletes an instance of the given resource

```ruby
bbva_resource.delete(object_id,customer_id=nil)
```

#####all
   Returns an array of all instances of a resource
```ruby
bbva_resource.all(customer_id=nil)
```

##### each
   Returns a block for each instance resource
```ruby
bbva_resource.each(customer_id=nil)
 ```

##### delete_all(available only under the development environment)

   Deletes all instances of the given resource

```ruby
#in case this method is executed under the production environment an BbvaException will be raised.
bbva_resource.delete_all(customer_id=nil)
```


### API Methods

#### charges


 - creates merchant charge

        charges.create(charge_hash)

- gets merchant charge

        merchant_charge=charges.get(charge_id)

- capture merchant

        charges.capture(charge_id)

- confirm capture merchant

        #pass a hash with the following options
        confirm_capture_options = { transaction_id: transaction['id'], amount: 100  }
        charges.confirm_capture(confirm_capture_options)

- refund  merchant charge

        charges.refund(charge_id, refund_description_hash)


#### Tokens

- create token

        tokens.create(token_hash)


- get  token

        tokens.get(token_id)

#### Exceptions

This API generates 3 different Exception classes.

-  **BbvaException**: Generic base API exception class, Generic API exceptions.

     - Internal server error (500 Internal Server Error).
     - BbvaApi factory method, invalid resource name.

    Examples:

 ```ruby
  #production mode
  bbva_prod=BbvaApi.new(@merchant_id,@private_key,true)
  customers=bbva_prod.create(:customers)
  customers.delete_all # will raise an BbvaException
 ```

  ```ruby
   #production mode
   bbva_prod=BbvaApi.new(@merchant_id,@private_key,true)
   customers=bbva_prod.create(:non_existing_resource)    # will raise an BbvaException
  ```

-  **BbvaConnectionException**: Exception class for connection related issues, errors happening prior  the server connection.

     - Authentication Error (401 Unauthorized)
     - Connection Errors.
     - SSL Errors.

    Example:
     ```ruby
     #invalid id and key
     merchant_id='santa'
     private_key='invalid'

     bbva=BbvaApi.new(merchant_id, private_key)
     customers=bbva.create(:customers)

      begin
         customers.get('23444422211')
      rescue BbvaConnectionException => e
         e.http_code  #  => 401
         e.error_code # => 1002
         e.description# => 'The api key or merchant id are invalid.'
         e.json_body #  {"category":"request","description":"The api key or merchant id are invalid.","http_code":401,"error_code":1002,"request_id":null}
       end
     ```

- **BbvaTransactionException**: Errors happening after the initial connection has been initiated, errors during transactions.

   - Bad Request (e.g. Malformed json,Invalid data)
   - Unprocessable Entity (e.g. invalid data)
   - Resource not found (404 Not Found)
   - Conflict (e.g. resource already exists)
   - PaymentRequired (e.g. insufficient funds)
   - UnprocessableEntity ( e.g. stolen card )

 *Bad Request* Example:

```ruby
email='foo'
customer_hash = FactoryBot.build(:customer, email: email)
begin
    customers.create(customer_hash)
rescue BbvaTransactionException => e
    e.http_code# => 400
    e.error_code# => 1001
    e.description# => 'email\' not a well-formed email address'
end
  ```

  *Resource not found* Example:

```ruby
begin
  #non existing customer
  customers.delete('1111')
rescue BbvaApiTransactionError => e
  e.http_code# => 404
  e.error_code# =>1005
  e.description# =>"The customer with id '1111' does not exist"
end
```

### These exceptions have the following attributes:

- *category*
- *description*
- *http_code*
- *error_code*
- *json_message*

For more information about categories, descriptions and codes take a look at:
- http://docs.bbva.mx/#errores
- http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html


## Debug

In the Bbva dashboard you are able to see every request and its corresponding request/response.
    - https://sandbox-dashboard.bbva.mx

## Developer Notes

- bank accounts for merchant cannot be created using the api. It should be done through the dashboard.
- Is recommended to reset your account using the dashboard when running serious testing (assure clean state)
- check bbva_api.rb for Logger configuration
- travis  https://travis-ci.org/bbva-ruby , if a test fails it will leave some records, it may affect posterior tests.
   it is recommended to reset the console/account to assure a clean state after a failure occurs.

## More information
For more use cases take a look at the *test/spec* folder

  1. - https://docs.ecommercebbva.com
