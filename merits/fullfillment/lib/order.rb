module Fullfillments
  class Order
    include AggregateRoot

    AlreadyCreated = Class.new(StandardError)
    CanDeliverOnlyAfterCreation = Class.new(StandardError)
    CanAbortOnlyAfterCreation = Class.new(StandardError)

    def initialize(id)
      @id = id
    end

    def create(_)
      raise AlreadyCreated if @state == :created

      old_event = Orders::Events::Created.new( data: { id: @id } )
      new_version = Orders::Events::Convertors::Created_V1ToV2.new.( old_event )

      apply old_event, new_version
    end

    def deliver(command)
      raise CanDeliverOnlyAfterCreation unless @state == :created

      if(command.should_fail)
        event = Orders::Events::DeliveryFailed.new(data: {id: @id, reason: command.failure_reason})
      else
        event = Orders::Events::Delivered.new(data: {id: @id})
      end

      apply event
    end

    def abort(command)
      raise CanAbortOnlyAfterCreation unless @state == :created

      event = Orders::Events::Aborted.new(data: {id: @id, reason: command.reason})

      apply event
    end

  private

    on Orders::Events::Created do |event|
      @state = :created
      @amount = 1
    end

    on Orders::Events::CreatedV2 do |event|
      @state = :created
      @amount = event.data[:amount]
    end

    on Orders::Events::Delivered do |event|
      @state = :created
    end

    on Orders::Events::Aborted do |event|
      @state = :aborted
      @abort_reason = event.data[:reason]
    end

    on Orders::Events::DeliveryFailed do |event|
      @state = :delivery_failed
      @delivery_failure_reason = event.data[:reason]
    end
  end
end
