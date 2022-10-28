module Fullfillment
  class Transaction < ApplicationRecord
    class << self
      def call(event)
        amount = event.data[:amount]

        transaction_type = {
          Payments::Cards::Events::Authorized => 'authorized',
          Payments::Cards::Events::Released => 'released',
          Payments::Cards::Events::Captured => 'captured',
        }

        Transaction.create transaction_id: event.data[:id],
                           amount: amount,
                           order_id: 'n/a',
                           transaction_type: transaction_type[event.class]
      end
    end

    self.table_name = "transaction_reports"
    # t.string "transaction_id"
    # t.string "order_id"
    # t.decimal "amount"
    # t.string "transaction_type"
  end
end
