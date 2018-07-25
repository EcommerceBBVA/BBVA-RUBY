require 'bancomer_resource'

class Charges < BancomerResource

  def refund(transaction_id, description)
    post(description, transaction_id + '/refund')
  end

  def capture(transaction_id)
    post('', transaction_id + '/capture')
  end

  def confirm_capture(options)
    transaction_id = options.fetch(:transaction_id)
    amount = options.fetch(:amount)

    raise BancomerException if amount.nil? || transaction_id.nil?

    amount_hash = { amount: amount }
    post(amount_hash, transaction_id + '/capture')

  end

  def get(charge='')
    super charge
  end

  def create(charge)
    super charge
  end

end
