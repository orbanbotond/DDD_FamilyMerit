# frozen_string_literal: true

module DataMapper
  module Relations
    class CommandSource < ROM::Relation[:sql]
      schema(:command_sources, infer: true) do
        # attribute :properties, Types::PG::JSONB
        associations do
          # belongs_to :classification
        end
      end
    end
  end
end
