module TimeHarvest
  module Events
    class AccountCreatedForUser < ::Infra::Event

      attribute :user_id, Infra::Types::Strict::String
      attribute :account_id, Infra::Types::Strict::String
    end
  end
end
