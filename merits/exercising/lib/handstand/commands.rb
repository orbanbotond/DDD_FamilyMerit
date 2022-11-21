module Exercising
  module Handstand
    module Commands
      class StartHandstandPractice < Infra::Command
        attribute :user_id, Infra::Types::Strict::String
      end

      class RecordHandstandSetupTime < Infra::Command
        attribute :seconds, Infra::Types::Strict::Integer
        attribute :user_id, Infra::Types::Strict::String
      end

      class RecordHandstandTime < Infra::Command
        attribute :seconds, Infra::Types::Strict::Integer
        attribute :user_id, Infra::Types::Strict::String
      end

      class RecordPause < Infra::Command
        attribute :user_id, Infra::Types::Strict::String
      end

      class FinishHandstandPractice < Infra::Command
        attribute :user_id, Infra::Types::Strict::String
      end
    end
  end
end
