module Fullfillments
  module Orders
    module Events
      class Created < ::Infra::Event
        attribute :id, Infra::Types::Strict::String
      end
      class Delivered < ::Infra::Event
        attribute :id, Infra::Types::Strict::String
      end
      class Aborted < ::Infra::Event
        attribute :id, Infra::Types::Strict::String
        attribute :reason, Infra::Types::Strict::String
      end
      class DeliveryFailed < ::Infra::Event
        attribute :id, Infra::Types::Strict::String
        attribute :reason, Infra::Types::Strict::String
      end
    end
  end
end
