module TimeHarvest
	class CreateAccountHandler
		def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
		end

    def call(command)
      @repository.with_aggregate(Account, command.account_id) do |account|
        account.create_for(command.user_id)
      end
    end
	end

  class TimeConsumeHandler
    def initialize(event_store)
      @repository = Infra::AggregateRootRepository.new(event_store)
    end

    def call(command)
      @repository.with_aggregate(Account, command.account_id) do |account|
        account.consume_time(command.minutes, command.activity_id)
      end
    end
  end
end