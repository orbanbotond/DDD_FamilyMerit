module MyAggregateRoot
	def self.included(base)
    base.extend ClassMethods
    base.class_eval do
    end
  end

  module ClassMethods
		def event_handlers
			name = '@event_handlers'
			self.singleton_class.instance_variable_get(name) || self.singleton_class.instance_variable_set(name, {})
		end

		def on(event_type, &block)
			event_handlers[event_type] = block
		end
  end

	attr_accessor :version

	def initialize(aggregate_id, event_store, *args)
		@aggregate_id = aggregate_id
		@event_store = event_store

		setup_initial_state(*args) if respond_to?(:setup_initial_state)
		reconstruct_from_event_stream
	end

	def reconstruct_from_event_stream
		events = @event_store.read.stream(event_stream_name)

		events.each do |event|
			aggregate.(event)
		end
	end

	def event_stream_name
		"#{self.class}-#{@aggregate_id}"
	end

	def publish(event)
		self.(event)
		@event_store.publish(event, stream_name: event_stream_name)
	end

	def call(event)
		handler = self.class.event_handlers[event.class]
		self.instance_exec event, &handler
		binding.pry
	end
end
