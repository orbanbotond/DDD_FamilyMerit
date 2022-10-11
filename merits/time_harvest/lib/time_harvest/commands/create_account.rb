module TimeHarvest
  class CreateAccount < Infra::Command
    attribute :user_id, Infra::Types::Strict::String
    attribute :account_id, Infra::Types::Strict::String
  end
end
