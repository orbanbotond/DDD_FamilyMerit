module Gamification
  class AwardMember < Infra::Command
    attribute :user_id, Infra::Types::Strict::String
  end
end
