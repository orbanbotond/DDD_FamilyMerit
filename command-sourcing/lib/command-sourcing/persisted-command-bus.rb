require 'forwardable'

module PersistedCommandBus
  class CommandBus
    extend Forwardable
    def initialize
      @repository = CommandSourcing::DataMapper::DatabaseConnection.new(CommandSourcing::DataMapper::DatabaseConnection.connection_options).command_source_repo
      @arkency_command_bus = Arkency::CommandBus.new
    end

    def_delegators :@arkency_command_bus, :register

    def call(command)
      persist_command(command)
      arkency_command_bus.(command)
    end

    private
      attr_reader :arkency_command_bus, :repository

    def persist_command(command)
      repository.create properties: command.to_h
    end
  end
end
