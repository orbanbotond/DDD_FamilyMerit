module Fullfillment
  class Order < ApplicationRecord
    class Configuration
      def call(cqrs)
        @cqrs = cqrs

        subscribe_and_link_to_stream(
          ->(event) { record_transaction(event) },
          [
            Fullfillments::Orders::Events::Created,
            Fullfillments::Orders::Events::Delivered,
            Fullfillments::Orders::Events::Aborted,
            Fullfillments::Orders::Events::DeliveryFailed
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
        @cqrs.link_event_to_stream(event, "ReportOrders$all")
      end

      def subscribe(handler, events)
        @cqrs.subscribe(handler, events)
      end

      def record_transaction(event)
        case event
        when Fullfillments::Orders::Events::Created
          Order.create fullfillment_id: event.data[:id]
        when Fullfillments::Orders::Events::Delivered
          order = order_found_from_event(event)
          order.update delivered: true
        when Fullfillments::Orders::Events::Aborted
          order = order_found_from_event(event)
          order.update not_delivered: true
        when Fullfillments::Orders::Events::DeliveryFailed
          order = order_found_from_event(event)
          order.update not_delivered: true
        end
      end

      def order_found_from_event(event)
        Order.find_by fullfillment_id: event.data[:id]
      end
    end

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
