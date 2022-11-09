module Teams
  class CreateMember < Infra::Command
    attribute :id, Infra::Types::Strict::String
    attribute :email, Infra::Types::Strict::String
  end
end
