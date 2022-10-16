module Processes
	class TeamAchievement

		# class TeamMember < ActiveRecord::Base
	 #    self.table_name = "gamification_team_member"
		# end

    def initialize(cqrs)
      @cqrs = cqrs
    end

    def call(event)
    	# state = build_state(event)

 #  TODO
 #  can we read from a stream with wildcards?
 #  try save and publish to X$all
 #  then read from X$specific....
 #  write to X$specific & read from X$all
 #
 #  scope = client.read
 #  .stream('GoldCustomers')
 #  .backward
 #  .limit(100)
 #  .of_type([Customer::GoldStatusGranted])

    	case event
      when Teams::Events::TeamCreated
      	store_team_info(event)
      when Gamification::Events::MemberAwarded
      	puts "handling member awarded inside the process"
      	puts "handling member awarded inside the process"
      	puts "handling member awarded inside the process"
      	update_members(event)
      	teams = load_containing_teams(event)
      	awarding_teams = select_teams_eligible_for_award(teams)
      	award_teams(awarding_teams)
      end
    end

    private

    attr_reader :cqrs

    def build_state(event)
    	stream_name = "TeamAchievementProcess$#{event.data[:name]}"
      past_events = cqrs.all_events_from_stream(stream_name)
      last_stored = past_events.size - 1
      cqrs.link_event_to_stream(event, stream_name, last_stored)

      TeamState.new.tap do |state|
        past_events.each { |ev| state.call(ev) }
        state.call(event)
      end
    rescue RubyEventStore::WrongExpectedEventVersion
      retry
    end

    def store_team_info(event)
    	team_name = event.data[:name]
    	event.data[:members].each do |member|
    		# TeamMember.create team_name: team_name, user_id: member[:user_id], ratio: 0
    	end
    end

    def update_members(event)
    	# TeamMember.where(user_id: event.data[:user_id]).update_all(ratio: 2)
    end

    def load_containing_teams(event)
    	# team_names = TeamMember.find_by(user_id: event.data[:user_id]).select(:team_name).distinct
    	team_names.map do | team_name|
    		{ 
    			team_name: team_name,
    			# members: TeamMember.where(team_name: team_name).select(:ratio, :user_id).map{|user|{user_id: user.user_id, ratio: user.ratio}}
    		}
    	end
    end

    def select_teams_eligible_for_award(teams)
    	teams.select{|team| team[:members].all{|member| member.ratio == 2 }}
    end

    def award_teams(teams)
    	teams.each do |team|
	      cqrs.run_command(Gamification::AwardTeam.new(name: team[:team_name]))
    	end
    end

    class TeamState
    	attr_reader :user_id

      def initialize
      	@credits = []
      	@debits = []
      	@user_id = nil
      end

      def call(event)
        case event
        when Teams::Events::TeamCreated
        	# @debits << event.data[:minutes]
        when Gamification::Events::MemberAwarded
        	# @credits << event.data[:minutes]
        end
      end
    end
	end
end
