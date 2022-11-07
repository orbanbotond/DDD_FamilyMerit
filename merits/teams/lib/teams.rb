# frozen_string_literal: true

require 'infra'
require_relative 'teams/events/team_created.rb'
require_relative 'teams/teams_service'
require_relative 'teams/commands/create_team'
require_relative 'teams/commands/create_member'
require_relative 'teams/commands/achieve_double_bronze'
require_relative 'teams/events/team_created'
require_relative 'teams/events/member_created'
require_relative 'teams/formation'
require_relative 'teams/member'
require_relative 'data_mapper/database_connection.rb'

$teams_environment ||= ENV['ENVIRONMENT'] || :development

module Teams
	class Configuration
		def call(cqrs)
			cqrs.register_command(CreateTeam, CreateTeamHandler.new(cqrs.event_store), Events::TeamCreated)
			cqrs.register_command(CreateMember, CreateMemberHandler.new(cqrs.event_store), Events::MemberCreated)
		end
	end
end
