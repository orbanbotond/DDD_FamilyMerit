# frozen_string_literal: true

require 'rom-sql'
require 'yaml'
require 'erb'
require_relative 'relations/member_info'
require_relative 'repositories/member_repository'

module Teams
  module DataMapper
    class DatabaseConnection
      class << self
        def connection_options
          db_config_file_location = File.join __dir__, '..', '..', 'config', 'database.yml'
          erb = ERB.new( File.read( db_config_file_location))
          db_config = YAML.safe_load(erb.result, aliases: true)
          db_config[$teams_environment.to_s]
        end

        def connection_uri(options)
          "postgres://#{options['username']}:#{options['password']}@#{options['host']}:#{options['port']}/#{options['database']}"
        end
      end

      attr_reader :member_repo

      def initialize(db_config = {})
        @config = ROM::Configuration.new(:sql, self.class.connection_uri(self.class.connection_options), db_config)
        @config.register_relation(DataMapper::Relations::MemberInfo)

        @rom_container = ROM.container(@config)
        @member_repo = DataMapper::Repositories::MemberRepository.new(container: @rom_container)
      end
    end
  end
end
