module TimeHarvest
  module Events
    class TimeConsumedOnActivity < ::Infra::Event

      attribute :minutes, Infra::Types::Strict::Integer.constrained(gt: 0)
      attribute :activity_id, Infra::Types::Strict::String
      attribute :account_id, Infra::Types::Strict::String.optional
    end
  end
end
