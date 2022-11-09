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

    def replay_history
      historycal_commands.each do |command|
        self.(command)
      end
    end

    def historycal_commands
      repository.all_commands.map do |record|
        record.command_type.constantize.new record.properties.symbolize_keys
      end
    end

    private
      attr_reader :arkency_command_bus, :repository

    def persist_command(command)
      repository.create properties: command.to_h, command_type: command.class.to_s, creation_timestamp: Time.now
    end
  end
end
