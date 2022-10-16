# frozen_string_literal: true

require 'rom-sql'
require 'yaml'
require 'erb'
require_relative 'relations/team_member_info'
require_relative 'repositories/teams_repository'

# config->container
# relation -> schema/commands
# repository -> commands/query methods

# postgresql_config.default.create_table(:employees) do
#   primary_key :id
#   # classification, :payment_method, :affiliation, :name, :address
#   column :name, String, null: false
#   column :address, String, null: false
# end
# postgresql_config.default.create_table(:schedules) do
#   primary_key :id
#   column :type, String, null: false
#   column :employee_id, String, null: false
# end

module DataMapper
  class DatabaseConnection
    class << self
      def connection_options
        db_config_file_location = File.join __dir__, '..', '..', 'config', 'database.yml'
        erb = ERB.new( File.read( db_config_file_location))
        db_config = YAML.safe_load(erb.result(binding), aliases: true)
        puts 'Env'
        puts 'Env'
        puts 'Env'
        puts 'Env'
        puts $processes_environment.to_s
        puts $processes_environment.to_s
        puts $processes_environment.to_s
        db_config[$processes_environment.to_s]
      end

      def connection_uri(options)
        "postgres://#{options['username']}:#{options['password']}@#{options['host']}:#{options['port']}/#{options['database']}"
      end
    end

    attr_reader :teams_repo

    def initialize(db_config = {})
      @config = ROM::Configuration.new(:sql, self.class.connection_uri(self.class.connection_options), db_config)
      @config.register_relation(DataMapper::Relations::TeamMemberInfo)

      @rom_container = ROM.container(@config)
      @teams_repo = DataMapper::Repositories::TeamMembersRepository.new(container: @rom_container)
    end
  end
end
