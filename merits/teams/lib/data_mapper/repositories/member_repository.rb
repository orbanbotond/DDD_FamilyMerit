# frozen_string_literal: true

require 'rom-repository'

module Teams
  module DataMapper
    module Repositories
      class MemberRepository < ROM::Repository[:members_info]
        commands :create, update: :by_pk

        def by_id(id)
          members_info.by_pk(id).one!
        end
      end
    end
  end
end
