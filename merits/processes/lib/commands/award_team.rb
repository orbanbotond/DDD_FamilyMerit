module Gamification
  class AwardTeam < Infra::Command
    attribute :name, Infra::Types::Strict::String
  end
end
