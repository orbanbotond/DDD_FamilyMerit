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

	def apply(event)
		call_handler(event)

		unpublished_events << event
	end

	def call_handler(event)
		block = self.class.event_handlers[event.class]
		block.call(event)
	end

	def unpublished_events
		@unpublished_events ||= []
	end

	def call(event)
		call_handler(event)
	end
end
