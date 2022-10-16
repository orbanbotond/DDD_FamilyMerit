# frozen_string_literal: true

require 'rom-repository'

module DataMapper
  module Repositories
    class TeamMembersRepository < ROM::Repository[:team_members_info]
      commands :create, update: :by_pk
    end
  end
end
