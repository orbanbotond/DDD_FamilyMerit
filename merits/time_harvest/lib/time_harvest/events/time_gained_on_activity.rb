module TimeHarvest
  module Events
    class TimeGainedOnActivity < ::Infra::Event

      attribute :minutes, Infra::Types::Strict::Integer.constrained(gt: 0)
      attribute :activity_id, Infra::Types::Strict::String
    end
  end
end
