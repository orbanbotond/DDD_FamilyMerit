require_relative 'data_mapper/database_connection.rb'
require_relative 'command-sourcing/persisted-command-bus.rb'

$command_sourcing_environment ||= ENV['ENVIRONMENT'] || :development
