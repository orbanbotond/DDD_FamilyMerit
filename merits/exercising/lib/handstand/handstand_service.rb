module Exercising
  module Handstand
    class StartHandstandPracticeHandler
      def initialize(event_store)
        @repository = Infra::AggregateRootRepository.new(event_store)
      end

      def call(command)
        @repository.with_aggregate(HandstandPractice, command.user_id) do |handstand|
          handstand.start_practice
        end
      end
    end

    class RecordHandstandSetupTimeHandler
      def initialize(event_store)
        @repository = Infra::AggregateRootRepository.new(event_store)
      end

      def call(command)
        @repository.with_aggregate(HandstandPractice, command.user_id) do |handstand|
          handstand.setup(command.seconds)
        end
      end
    end

    class RecordHandstandTimeHandler
      def initialize(event_store)
        @repository = Infra::AggregateRootRepository.new(event_store)
      end

      def call(command)
        @repository.with_aggregate(HandstandPractice, command.user_id) do |handstand|
          handstand.handstand(command.seconds)
        end
      end
    end

    class RecordPauseHandler
      def initialize(event_store)
        @repository = Infra::AggregateRootRepository.new(event_store)
      end

      def call(command)
        @repository.with_aggregate(HandstandPractice, command.user_id) do |handstand|
          handstand.pause
        end
      end
    end

    class RecordFinishPracticeHandler
      def initialize(event_store)
        @repository = Infra::AggregateRootRepository.new(event_store)
      end

      def call(command)
        @repository.with_aggregate(HandstandPractice, command.user_id) do |handstand|
          handstand.end_practice
        end
      end
    end
  end
end