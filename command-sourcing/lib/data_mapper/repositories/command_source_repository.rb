# frozen_string_literal: true

require 'rom-repository'

module DataMapper
  module Repositories
    class CommandSourceRepository < ROM::Repository[:command_sources]
      commands :create
    end
  end
end
