require 'infra'

require_relative 'events'
require_relative 'commands'

module Payments
  class AuthorizePaymentHandler
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Card, command.id) do |order|
        order.authorize(command)
      end
    end
  end
  class ReleasePaymentHandler
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Card, command.id) do |order|
        order.release(command)
      end
    end
  end
  class CapturePaymentHandler
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Card, command.id) do |order|
        order.capture(command)
      end
    end
  end

  class Configuration
    def call(cqrs)
      cqrs.register_command(Cards::Commands::Authorize, AuthorizePaymentHandler.new(cqrs.event_store), Cards::Events::Authorized)
      cqrs.register_command(Cards::Commands::Capture, CapturePaymentHandler.new(cqrs.event_store), [Cards::Events::CaptureFailed, Cards::Events::Captured])
      cqrs.register_command(Cards::Commands::Release, ReleasePaymentHandler.new(cqrs.event_store), [Cards::Events::ReleaseFailed, Cards::Events::Released])
    end
  end

  class Gateway
    def success?
      true
    end
  end

  class Card
    include AggregateRoot

    def initialize(id)
      @id = id
    end

    CanReleaseOnlyAfterAuthorization = Class.new(StandardError)
    CanCaptureOnlyAfterAuthorization = Class.new(StandardError)    

    def authorize(command)
      event = if Gateway.new.success?
        Cards::Events::Authorized.new(data:{id: @id})
      else
        Cards::Events::AuthorizationFailed.new(data:{id: @id, reason: 'Whatever'})
      end

      apply event
    end

    def capture(command)
      raise CanCaptureOnlyAfterAuthorization unless @state == :authorized

      event = if Gateway.new.success?
        Cards::Events::Captured.new(data:{id: @id})
      else
        Cards::Events::CaptureFailed.new(data:{id: @id, reason: 'Whatever'})
      end

      apply event
    end

    def release(command)
      raise CanReleaseOnlyAfterAuthorization unless @state == :authorized

      event = if Gateway.new.success?
        Cards::Events::Released.new(data:{id: @id})
      else
        Cards::Events::ReleaseFailed.new(data:{id: @id, reason: 'Whatever'})
      end

      apply event
    end

    private

    on Cards::Events::Released do |event|
      @state = :released
    end

    on Cards::Events::ReleaseFailed do |event|
      @state = :release_failed
    end

    on Cards::Events::Authorized do |event|
      @state = :authorized
    end

    on Cards::Events::AuthorizationFailed do |event|
      @state = :authorization_failed
    end

    on Cards::Events::Captured do |event|
      @state = :captured
    end

    on Cards::Events::CaptureFailed do |event|
      @state = :capture_failed
    end
  end
end
