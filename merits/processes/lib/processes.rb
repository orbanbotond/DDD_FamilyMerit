# frozen_string_literal: true

require 'infra'
# require 'activerecord'
require_relative '../../teams/lib/teams'
require_relative '../../time_harvest/lib/time_harvest'
require_relative 'events/member_awarded'
require_relative 'events/team_awarded'
require_relative 'commands/award_member'
require_relative 'commands/award_team'
require_relative '../../fullfillment/lib/fullfillment'
require_relative 'processes/team_achievement'
require_relative 'processes/member_achievement'
require_relative 'processes/order_fullfillment'
require_relative 'processes/processes_service'
require_relative 'data_mapper/database_connection.rb'

$processes_environment ||= ENV['ENVIRONMENT'] || :development

module Processes
	class Configuration
		def call(cqrs)
			register_commands(cqrs)

      register_user_award_process(cqrs)
      register_order_fullfillment_process(cqrs)
		end

		private

		def register_commands(cqrs)
			cqrs.register_command(Gamification::AwardMember, Gamification::AwardMemberHandler.new(cqrs.event_store), Gamification::Events::MemberAwarded)
		end

		def register_order_fullfillment_process(cqrs)
	    cqrs.subscribe(
	    	Processes::OrderFullfillment.new(cqrs),
	    	[
	    		Fullfillments::Orders::Events::Created,
	    		Payments::Cards::Events::Authorized,
	    		Payments::Cards::Events::AuthorizationFailed,
	    		Fullfillments::Orders::Events::Delivered,
	    		Fullfillments::Orders::Events::DeliveryFailed,
	    		Payments::Cards::Events::Captured,
	    		Payments::Cards::Events::CaptureFailed,
	    		Payments::Cards::Events::Released,
	    		Payments::Cards::Events::ReleaseFailed,
	    	]
	    )
		end

		def register_user_award_process(cqrs)
      cqrs.subscribe(
      	TeamAchievement.new(cqrs),
      	[
      		Teams::Events::TeamCreated,
      		Gamification::Events::MemberAwarded
      	]
      )
      cqrs.subscribe(
      	MemberAchievement.new(cqrs),
      	[
      		TimeHarvest::Events::TimeConsumedOnActivity,
      		TimeHarvest::Events::TimeGainedOnActivity
      	]
      )
		end
	end
end
