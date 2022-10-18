module Teams
	class CreateTeamHandler
		def initialize(event_store)
      @repository = MyAggregateRootRepository.new(event_store)
		end

    def call(command)
      @repository.reconstruct_aggreagate_then_publish(Formation, command.name) do |formation|
        formation.create(command.name, command.members)
      end
    end
	end
end