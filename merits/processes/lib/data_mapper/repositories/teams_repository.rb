# frozen_string_literal: true

require 'rom-repository'

module DataMapper
  module Repositories
    class TeamMembersRepository < ROM::Repository[:team_members_info]
      commands :create, update: :by_pk

      def update_by_id(user_id, ratio)
        team_members_info
          .where(user_id: user_id.to_s).each do |team_member|
            self.update(team_member.id, ratio: ratio)
          end
      end

      def team_names(user_id)
        team_members_info
          .where(user_id: user_id.to_s)
          .select(:team_name).to_a.map(&:team_name)
      end

      def by_team_name(team_name)
        team_members_info
          .where(team_name: team_name)
      end
    end
  end
end
