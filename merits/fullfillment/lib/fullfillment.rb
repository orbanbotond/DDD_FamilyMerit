require 'infra'

require_relative 'events'
require_relative 'commands'
require_relative 'order'
require_relative 'event_stream_relinker'
require_relative '../../payments/lib/payment'

module Fullfillments
	class CreateOrderHandler
		def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
		end

    def call(command)
      @repository.with_aggregate(Order, command.id) do |order|
        order.create(command)
      end
    end
	end

	class AbortOrderHandler
		def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
		end

    def call(command)
      @repository.with_aggregate(Order, command.id) do |order|
        order.abort(command)
      end
    end
	end

	class DeliverOrderHandler
		def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
		end

    def call(command)
      @repository.with_aggregate(Order, command.id) do |order|
        order.deliver(command)
      end
    end
	end

	class Configuration
		def call(cqrs)
			register_commands(cqrs)
			register_relinkers(cqrs)
		end

private

		def register_commands(cqrs)
			cqrs.register_command(Fullfillments::Orders::Commands::Create, CreateOrderHandler.new(cqrs.event_store), Orders::Events::Created)
			cqrs.register_command(Fullfillments::Orders::Commands::Abort, AbortOrderHandler.new(cqrs.event_store), Orders::Events::Aborted)
			cqrs.register_command(Fullfillments::Orders::Commands::Deliver, DeliverOrderHandler.new(cqrs.event_store), [Orders::Events::Delivered, Orders::Events::DeliveryFailed])
		end

		def register_relinkers(cqrs)
			cqrs.subscribe(Fullfillments::EventStreamRelinker.new(cqrs), [Fullfillments::Orders::Events::Created])
		end
	end
end
