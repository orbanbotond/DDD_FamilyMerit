# frozen_string_literal: true

require 'rom-repository'

module DataMapper
  module Repositories
    class CommandSourceRepository < ROM::Repository[:command_sources]
      commands :create

      def all_commands
        command_sources.select(:properties, :command_type).to_a
      end
    end
  end
end
