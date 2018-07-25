require 'factory_bot'


FactoryBot.define do

  factory :customer, class: Hash do
    name 'Guadalupe'
    last_name 'Reyes'
    email 'lupereyes@lemail.com'
    phone_number '0180012345'
    address { {
        postal_code: '76190',
        state: 'QRO',
        line1: 'LINE1',
        line2: 'LINE2',
        line3: 'LINE3',
        country_code: 'MX',
        city: 'Queretaro',
    } }

    initialize_with { attributes }

  end

  factory :token, class: Hash do
    card_number '4111111111111111'
    holder_name 'Vicente Olmos'
    expiration_month '09'
    expiration_year '20'
    cvv2 '111'
    address { {
        postal_code: '76190',
        state: 'QRO',
        line1: 'LINE1',
        line2: 'LINE2',
        line3: 'LINE3',
        country_code: 'MX',
        city: 'Queretaro',
    } }

    initialize_with { attributes }

  end

  factory :token_charge, class: Hash do
    affiliation_bbva '720931'
    amount '10.00'
    description 'Primer cargo'
    customer_language 'SP'
    capture 'TRUE'
    use_3d_secure 'FALSE'
    use_card_points 'NONE'
    currency 'MXN'
    order_id 'oid-00050'

    initialize_with { attributes }

  end

  factory :refund_description, class: Hash do
    description 'A peticion del cliente'
    initialize_with { attributes }

  end

end
