module Fullfillments
  module Orders
    module Commands
      class Create < Infra::Command
        attribute :id, Infra::Types::Strict::String
      end

      class Deliver < Infra::Command
        attribute :id, Infra::Types::Strict::String
        attribute :should_fail, Infra::Types::Strict::Bool
        attribute :failure_reason, Infra::Types::Strict::String.optional
      end

      class Abort < Infra::Command
        attribute :id, Infra::Types::Strict::String
        attribute :reason, Infra::Types::Strict::String
      end
    end
  end
end
