module Teams
  class CreateTeam < Infra::Command
    attribute :name, Infra::Types::Strict::String
    attribute :members, Infra::Types::Array.of(Infra::Types::Hash.schema(user_id: Infra::Types::String))
  end
end
