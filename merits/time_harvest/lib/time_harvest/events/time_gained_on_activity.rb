module TimeHarvest
  module Events
    class TimeGainedOnActivity < ::Infra::Event

      attribute :activity_id, Infra::Types::Strict::String
      attribute :minutes, Infra::Types::Strict::Integer.constrained(gt: 0)
      attribute :account_id, Infra::Types::Strict::String
    end
  end
end
