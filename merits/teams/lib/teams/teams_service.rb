module Teams
	class CreateTeamHandler
		def initialize(event_store)
      @event_store = event_store
		end

    def call(command)
      formation = Formation.new(command.name, @event_store)
      formation.create(command.name, command.members)
    end
	end
end