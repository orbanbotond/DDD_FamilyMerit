module Fullfillment
  class Order < ApplicationRecord
    # class Configuration
    #   def call(cqrs)
    #     @cqrs = cqrs

    #     subscribe_and_link_to_stream(
    #       ->(event) { record_transaction(event) },
    #       [
    #         # Payments::Cards::Events::Create,
    #         # Payments::Cards::Events::Deliver,
    #         # Payments::Cards::Events::Authorized,
    #         # Payments::Cards::Events::Captured,
    #         # Payments::Cards::Events::Released,
    #       ]
    #     )
    #   end

    #   private

    #   def subscribe_and_link_to_stream(handler, events)
    #     link_and_handle = ->(event) do
    #       link_to_stream(event)
    #       handler.call(event)
    #     end
    #     subscribe(link_and_handle, events)
    #   end

    #   def link_to_stream(event)
    #     @cqrs.link_event_to_stream(event, "ReportOrders$all")
    #   end

    #   def subscribe(handler, events)
    #     @cqrs.subscribe(handler, events)
    #   end

    #   def record_transaction(event)
    #     Transaction.create transaction_id: event.data[:id],
    #                        amount: amount,
    #                        order_id: 'n/a',
    #                        transaction_type: transaction_type[event.class]
    #   end
    # end

    self.table_name = "fullfillment_reports"
    # t.string "fullfillment_id"
    # t.string "transaction_id"
    # t.boolean "payment_authorized"
    # t.boolean "payment_captured"
    # t.boolean "payment_released"
    # t.boolean "delivered"
    # t.boolean "not_delivered"
  end
end
