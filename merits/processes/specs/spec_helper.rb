ENV['ENVIRONMENT'] = 'test'

require 'database_cleaner-sequel'
require 'pry-nav'
require_relative '../lib/processes'

module Processes
  module TestPlumbing
    class FakeCommandBus
      attr_reader :last_received, :all_received

      def initialize
        @all_received = []
      end

      def call(command)
        @last_received = command
        @all_received << command
      end

      def register(command, handler)
      end
    end

    def self.included(klass)
      klass.include Infra::TestPlumbing

      klass.send(:let, :command_bus) { FakeCommandBus.new }

      klass.send(:before, :each) do
        Configuration.new.call(cqrs)
      end

      def given(events, store: event_store)
        events.each { |ev| store.append(ev) }
        events
      end

      extend RSpec::Matchers::DSL

      def expect_have_been_commanded(*expected_commands)
        expected_commands.all? do |expected_command|
          expect(command_bus.all_received ).to include(expected_command)
        end
      end

      def expect_nothing_have_been_commanded
        expect(command_bus.all_received ).to be_empty
      end

      def account_created_for(user_id, account_id)
        TimeHarvest::Events::AccountCreatedForUser.new( data: {
          user_id: user_id,
          account_id: account_id
        })
      end

      def member_awarded(user_id)
        Gamification::Events::MemberAwarded.new( data: {
          user_id: user_id,
        })
      end

      def time_gained_for(account_id, minutes, activity_id)
        TimeHarvest::Events::TimeGainedOnActivity.new( data: {
          account_id: account_id,
          minutes: minutes,
          activity_id: activity_id
        })
      end

      def time_consumed_for(account_id, minutes, activity_id)
        TimeHarvest::Events::TimeConsumedOnActivity.new( data: {
          account_id: account_id,
          minutes: minutes,
          activity_id: activity_id
        })
      end

      def team_created(name, *user_ids)
        Teams::Events::TeamCreated.new( data: {
          name: name,
          members: user_ids.map{|id| { user_id: id } }
        })
      end
    end
  end
end


DatabaseCleaner[:sequel].db = Sequel.connect(DataMapper::DatabaseConnection.connection_uri(DataMapper::DatabaseConnection.connection_options))

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner[:sequel].strategy = :truncation
  end
  config.before(:each) do
    DatabaseCleaner[:sequel].start
  end
  config.after(:each) do
    DatabaseCleaner[:sequel].clean
  end
end
