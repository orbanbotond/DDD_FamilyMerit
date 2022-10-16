module Gamification
	class AwardMemberHandler
		def initialize(event_store)
      @event_store = event_store
		end

    def call(command)
      puts "handling member award"

      event = Gamification::Events::MemberAwarded.new(data: { user_id: command.user_id })

      @event_store.publish(event, stream_name: "GamificationMember$#{command.user_id}")
      puts "handling member award event published"
    end
	end
end