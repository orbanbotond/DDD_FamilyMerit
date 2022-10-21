module Payments
  module Cards
    module Commands
      class Authorize < Infra::Command
        attribute :id, Infra::Types::Strict::String
      end

      class Capture < Infra::Command
        attribute :id, Infra::Types::Strict::String
      end

      class Release < Infra::Command
        attribute :id, Infra::Types::Strict::String
      end
    end
  end
end
