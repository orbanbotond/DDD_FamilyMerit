module TimeHarvest
  class GainTime < Infra::Command
    attribute :account_id, Infra::Types::Strict::String
    attribute :minutes, Infra::Types::Strict::Integer
    attribute :activity_id, Infra::Types::Strict::String
  end
end
