module Fullfillments
  class EventStreamRelinker
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call(event)
      @cqrs.event_store.link(event.event_id, stream_name: 'Fullfillments::Orders::Created', expected_version: :any)
    end
  end
end