# frozen_string_literal: true

module DataMapper
  module Relations
    class TeamMemberInfo < ROM::Relation[:sql]
      schema(:team_members_info, infer: true) do
        associations do
          # belongs_to :classification
        end
      end
    end
  end
end
