module Fullfillments
  module Orders
    module Events

      module Convertors
        class Created_V1ToV2
          def call(v1)
            CreatedV2.new(data: v1.data.merge( amount: 1))
          end
        end
      end

      class Created < ::Infra::Event
        attribute :id, Infra::Types::Strict::String
      end

      class CreatedV2 < Infra::Event
        attribute :id, Infra::Types::Strict::String
        attribute :amount, Infra::Types::Strict::Integer.optional
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
