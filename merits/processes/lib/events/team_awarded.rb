module Gamification
  module Events
    class TeamAwarded < ::Infra::Event
      attribute :name, Infra::Types::Strict::String
    end
  end
end
