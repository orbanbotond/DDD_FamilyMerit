module Processes
	class MemberAchievement
    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call(event)
      state = build_user_state(event)
      award_member(event, user) if state.credit_debit_ratio_is_reached?
    end

    private

    attr_reader :cqrs

    def award_member(event, user)
    	puts "awarding"
      cqrs.run_command(Gamification::AwardMember.new(user_id: event.data[:account_id]))
    end

    def build_user_state(event)
    	stream_name = "UserAchievementProcess$#{event.data[:account_id]}"
      past_events = cqrs.all_events_from_stream(stream_name)
      last_stored = past_events.size - 1
      cqrs.link_event_to_stream(event, stream_name, last_stored)

      UserState.new.tap do |state|
        past_events.each { |ev| state.call(ev) }
        state.call(event)
      end
    rescue RubyEventStore::WrongExpectedEventVersion
      retry
    end

    class UserState
    	attr_reader :user_id

      def initialize
      	@credits = []
      	@debits = []
      	@user_id = nil
      end

      def call(event)
      	@user_id = event.data[:account_id] if @user_id.nil?

        case event
        when TimeHarvest::Events::TimeConsumedOnActivity
        	@debits << event.data[:minutes]
        when TimeHarvest::Events::TimeGainedOnActivity
        	@credits << event.data[:minutes]
        end
      end

      def ratio
    		total_credits = @credits.sum
    		total_debits = @debits.sum
    		@ratio ||= total_credits.to_f / total_debits.to_f
      end

      def credit_debit_ratio_is_reached?
				ratio >= 2
      end
    end
	end
end
