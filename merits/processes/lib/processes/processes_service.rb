module Gamification
	class AwardMemberHandler
		def initialize(event_store)
      @event_store = event_store
		end

    def call(command)
      event = Gamification::Events::MemberAwarded.new(data: { user_id: command.user_id })

      @event_store.publish(event, stream_name: "GamificationMember$#{command.user_id}")
    end
	end
end