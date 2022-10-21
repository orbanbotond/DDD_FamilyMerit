module Fullfillment
  class Transaction < ApplicationRecord
    class Configuration
      def call(cqrs)
        @cqrs = cqrs

        subscribe_and_link_to_stream(
          ->(event) { record_transaction(event) },
          [
            Payments::Cards::Events::Authorized,
            Payments::Cards::Events::Captured,
            Payments::Cards::Events::Released,
          ]
        )
      end

      private

      def subscribe_and_link_to_stream(handler, events)
        link_and_handle = ->(event) do
          link_to_stream(event)
          handler.call(event)
        end
        subscribe(link_and_handle, events)
      end

      def link_to_stream(event)
        @cqrs.link_event_to_stream(event, "ReportFullfillment$all")
      end

      def subscribe(handler, events)
        @cqrs.subscribe(handler, events)
      end

      def record_transaction(event)
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
    # fields:
    # - username
    # - user_id
    # - total_time_gained
    # - total_time_consumed
    # - balance
    # - last 3 days trend: up/down
  end
end
