# frozen_string_literal: true

module Teams
  module DataMapper
    module Relations
      class MemberInfo < ROM::Relation[:sql]
        schema(:members_info, infer: true) do
          associations do
            # belongs_to :classification
          end
        end
      end
    end
  end
end
