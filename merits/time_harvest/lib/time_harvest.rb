# frozen_string_literal: true

require 'infra'
require_relative 'time_harvest/events/account_created_for_user'
require_relative 'time_harvest/events/time_consumed_on_activity'
require_relative 'time_harvest/events/time_gained_on_activity'
require_relative 'time_harvest/spent_time'
require_relative 'time_harvest/account'
require_relative 'time_harvest/time_harvest_service'
require_relative 'time_harvest/commands/create_account'
require_relative 'time_harvest/commands/consume_time'

module TimeHarvest
	class Configuration
		def call(cqrs)
			cqrs.register_command(CreateAccount, CreateAccountHandler.new(cqrs.event_store), Events::AccountCreatedForUser)
			cqrs.register_command(ConsumeTime, TimeConsumeHandler.new(cqrs.event_store), Events::TimeConsumedOnActivity)
		end
	end
end
