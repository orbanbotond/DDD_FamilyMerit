module Teams
  module Events
    class MemberCreated < ::Infra::Event
      attribute :id, Infra::Types::Strict::String
    end
  end
end
