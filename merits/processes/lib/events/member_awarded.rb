module Gamification
  module Events
    class MemberAwarded < ::Infra::Event
      attribute :user_id, Infra::Types::Strict::String
    end
  end
end
