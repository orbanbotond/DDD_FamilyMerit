module Processes
	class OrderFullfillment
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call(event)
      case event
      when Fullfillments::Orders::Events::Created
        cqrs.run_command(Payments::Cards::Commands::Authorize.new( id: event.data[:id] ))          
      when Payments::Cards::Events::AuthorizationFailed
        cqrs.run_command(Fullfillments::Orders::Commands::Abort.new( id: event.data[:id], reason: 'Can not authorize Card' ))
      when Fullfillments::Orders::Events::Delivered
        cqrs.run_command(Payments::Cards::Commands::Capture.new( id: event.data[:id]))
      when Payments::Cards::Events::Captured
        cqrs.event_store.link(event.event_id, stream_name: 'Fullfillments::Payment::Captured', expected_version: :any)
      when Payments::Cards::Events::CaptureFailed
        cqrs.run_command(Fullfillments::Orders::Commands::ManualInvestigate.new( id: event.data[:id]))
        cqrs.event_store.link(event.event_id, stream_name: 'Fullfillments::Payment::CaptureFailed', expected_version: :any)
      when Fullfillments::Orders::Events::DeliveryFailed
        cqrs.run_command(Payments::Cards::Commands::Release.new( id: event.data[:id]))
      when Payments::Cards::Events::ReleaseFailed
        cqrs.run_command(Fullfillments::Orders::Commands::ManualInvestigate.new( id: event.data[:id]))
      when Payments::Cards::Events::Released
        cqrs.event_store.link(event.event_id, stream_name: 'Fullfillments::Payment::Released', expected_version: :any)
      end
    end

    private

    attr_reader :cqrs
  end
end
