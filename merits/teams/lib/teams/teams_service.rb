module Teams
	class CreateTeamHandler
		def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
		end

    def call(command)
      @repository.with_aggregate(Formation, command.name) do |formation|
        formation.create(command.name, command.members)
      end
    end
	end
end