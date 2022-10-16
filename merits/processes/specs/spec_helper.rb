require_relative '../lib/processes'

module Processes
  module TestPlumbing
    class FakeCommandBus
      attr_reader :received, :all_received

      def call(command)
        @received = command
        @all_received = @all_received ? @all_received << command : [command]
      end
    end

    def self.included(klass)
      klass.include Infra::TestPlumbing

      klass.send(:before, :each) do
        @command_bus = FakeCommandBus.new
      end

      klass.send(:before, :each) do
        Configuration.new.call(cqrs)
      end

      def given(events, store: event_store)
        events.each { |ev| store.append(ev) }
        events
      end

      extend RSpec::Matchers::DSL

      def expect_have_been_commanded(*expected_commands)
        expect(@command_bus.received ).to eq(expected_commands)
      end

      def expect_nothing_have_been_commanded
        expect(@command_bus.received ).to be_nil
      end

      def account_created_for(user_id, account_id)
        TimeHarvest::Events::AccountCreatedForUser.new( data: {
          user_id: user_id,
          account_id: account_id
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

      # def assert_command(command)
      #   assert_equal(command_bus.received, command)
      # end

      # def assert_all_commands(*commands)
      #   assert_equal(command_bus.all_received, commands)
      # end

      # def assert_no_command
      #   assert_nil(command_bus.received)
      # end
    end
  end
end