# frozen_string_literal: true

require 'rom-sql'
require 'yaml'
require 'erb'
require_relative 'relations/command_source'
require_relative 'repositories/command_source_repository'

module CommandSourcing
  module DataMapper
    class DatabaseConnection
      class << self
        def connection_options
          db_config_file_location = File.join __dir__, '..', '..', 'config', 'database.yml'
          erb = ERB.new( File.read( db_config_file_location))
          db_config = YAML.safe_load(erb.result, aliases: true)
          db_config[$command_sourcing_environment.to_s]
        end

        def connection_uri(options)
          "postgres://#{options['username']}:#{options['password']}@#{options['host']}:#{options['port']}/#{options['database']}"
        end
      end

      def initialize(db_config = {})
        @config = ROM::Configuration.new(:sql, self.class.connection_uri(self.class.connection_options), db_config)
        @config.register_relation(::DataMapper::Relations::CommandSource)

        @rom_container = ROM.container(@config)
        @command_source_repo = ::DataMapper::Repositories::CommandSourceRepository.new(container: @rom_container)
      end

      attr_reader :command_source_repo
    end
  end
end
