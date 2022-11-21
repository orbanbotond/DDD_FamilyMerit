require 'infra'
require_relative 'handstand/commands.rb'
require_relative 'handstand/events.rb'
require_relative 'handstand/handstand_service.rb'
require_relative 'handstand/handstand.rb'

module Exercising
	class Configuration
		def call(cqrs)
			cqrs.register_command(Handstand::Commands::StartHandstandPractice, Handstand::StartHandstandPracticeHandler.new(cqrs.event_store), Handstand::Events::HandstandPracticeStarted)
			cqrs.register_command(Handstand::Commands::RecordHandstandSetupTime, Handstand::RecordHandstandSetupTimeHandler.new(cqrs.event_store), [Handstand::Events::HandstandSetupSucceeded, Handstand::Events::HandstandSetupFailed])
			cqrs.register_command(Handstand::Commands::RecordHandstandTime, Handstand::RecordHandstandTimeHandler.new(cqrs.event_store), [Handstand::Events::HandstandSucceeded, Handstand::Events::HandstandFailed, Handstand::Events::HandstandPracticeProgressed])
			cqrs.register_command(Handstand::Commands::RecordPause, Handstand::RecordPauseHandler.new(cqrs.event_store), [])
			cqrs.register_command(Handstand::Commands::FinishHandstandPractice, Handstand::RecordFinishPracticeHandler.new(cqrs.event_store), [Handstand::Events::HandstandPracticeRegressed, Handstand::Events::HandstandPracticeFinished])
		end
	end
end

