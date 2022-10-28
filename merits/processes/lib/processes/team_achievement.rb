module Processes
  class TeamAchievement
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call(event)
      case event
      when Teams::Events::TeamCreated
        store_team_info(event)
      when Gamification::Events::MemberAwarded
        update_members(event)
        possible_teams = load_containing_teams(event)
        eligible_teams = select_teams_eligible_for_award(possible_teams)
        award_teams(eligible_teams)
      end
    end

    private

    attr_reader :cqrs

    def team_members_repo
      @repo ||= DataMapper::DatabaseConnection::new(DataMapper::DatabaseConnection.connection_options).teams_repo
    end

    def store_team_info(event)
      team_name = event.data[:name]
      event.data[:members].each do |member|
        team_members_repo.create team_name: team_name, user_id: member[:user_id], ratio:0
      end
    end

    def update_members(event)
      team_members_repo.update_by_id(event.data[:user_id], 2)
    end

    def load_containing_teams(event)
      team_names = team_members_repo.team_names(event.data[:user_id])
      members = team_members_repo.by_team_names(team_names)

      team_names.map do | team_name|
        {
          team_name: team_name,
          members: members.to_a.select{|member| member[:team_name] == team_name}
        }
      end
    end

    def select_teams_eligible_for_award(teams)
      teams.select do |team|
        team[:members].to_a.all? { |member| member[:ratio] == 2 }
      end
    end

    def award_teams(teams)
      teams.each do |team|
        cqrs.run_command(Gamification::AwardTeam.new(name: team[:team_name]))
      end
    end
  end
end
