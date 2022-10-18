class MyAggregateRootRepository
	def initialize(event_store)
		@event_store = event_store
	end

	def reconstruct_aggreagate_then_publish(aggregate_class, aggregate_id)
		stream_name = stream(aggregate_class, aggregate_id)
		events = @event_store.read.stream(stream_name)
		aggregate = aggregate_class.new(aggregate_id)

		events.each do |event|
			aggregate.(event)
		end

		yield(aggregate)
		aggregate.unpublished_events.each do |event|
			@event_store.publish(event, stream_name: stream_name)
		end

	end

	def stream(aggregate_class, aggregate_id)
		"MyStream#{aggregate_class},#{aggregate_id}"
	end
end
