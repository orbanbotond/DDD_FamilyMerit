module Payments
  module Cards
    module Events
      class Authorized < ::Infra::Event
        attribute :id, Infra::Types::Strict::String
      end
      class AuthorizationFailed < ::Infra::Event
        attribute :id, Infra::Types::Strict::String
        attribute :reason, Infra::Types::Strict::String
      end
      class Captured < ::Infra::Event
        attribute :id, Infra::Types::Strict::String
      end
      class CaptureFailed < ::Infra::Event
        attribute :id, Infra::Types::Strict::String
        attribute :reason, Infra::Types::Strict::String
      end
      class Released < ::Infra::Event
        attribute :id, Infra::Types::Strict::String
      end
      class ReleaseFailed < ::Infra::Event
        attribute :id, Infra::Types::Strict::String
        attribute :reason, Infra::Types::Strict::String
      end
    end
  end
end
