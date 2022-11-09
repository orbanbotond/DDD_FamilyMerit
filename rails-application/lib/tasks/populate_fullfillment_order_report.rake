desc "Recreate the FullFillmentOrder report table based on events."
task recreate_fullfillment_order_report: :environment do
  Fullfillment::Order.destroy_all

  event_store = Rails.configuration.event_store
  created_orders = event_store.read.stream('Fullfillments::Orders::Created')
  created_orders.each do |order_creation_event|
    order_id = order_creation_event.data[:id]
    order = Fullfillment::Order.create fullfillment_id: order_id

    order_events = event_store.read.stream("Fullfillments::Order$#{order_id}")
    order_events.each do |order_event|
      case order_event
      when Fullfillments::Orders::Events::Delivered
        order.update delivered: true 
      when Fullfillments::Orders::Events::DeliveryFailed
        order.update not_delivered: true 
      end
    end
  end
end