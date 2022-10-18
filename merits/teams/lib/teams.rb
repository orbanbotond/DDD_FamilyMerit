# frozen_string_literal: true

require 'infra'
require 'pry-nav'
require_relative 'teams/events/team_created.rb'
require_relative 'teams/formation'
require_relative 'teams/teams_service'
require_relative 'teams/commands/create_team'
require_relative 'teams/commands/achieve_double_bronze'
require_relative 'teams/events/team_created'

module Teams
	class Configuration
		def call(cqrs)
			cqrs.register_command(CreateTeam, CreateTeamHandler.new(cqrs.event_store), Events::TeamCreated)
		end
	end
end
