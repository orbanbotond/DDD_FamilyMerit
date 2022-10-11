module TimeHarvest
  class Report < ApplicationRecord
    class Configuration
      def call(cqrs)
        @cqrs = cqrs

        subscribe_and_link_to_stream(
          ->(event) { time_consumed(event) },
          [TimeHarvest::Events::TimeConsumedOnActivity]
        )
      end

      private

      def subscribe_and_link_to_stream(handler, events)
        link_and_handle = ->(event) do
          link_to_stream(event)
          handler.call(event)
        end
        subscribe(link_and_handle, events)
      end

      def link_to_stream(event)
        @cqrs.link_event_to_stream(event, "ClientOrders$all")
      end

      def subscribe(handler, events)
        @cqrs.subscribe(handler, events)
      end

      def time_consumed(event)
        account_id = event.data.fetch(:account_id)
        report = Report.find_by(account_id: account_id)
        unless report.present?
          # TODO make a 1-to n for user->accounts
          user = User.first
          report = Report.create account_id: account_id, 
                                 user_name: user.name,
                                 total_time_consumed: 0,
                                 total_time_gained: 0,
                                 balance: 0
        end
        report.total_time_consumed -= event.data.fetch(:minutes)
        report.balance -= event.data.fetch(:minutes)
        report.save!
      end
    end

    self.table_name = "time_harvest_reports"
    # fields:
    # - username
    # - user_id
    # - total_time_gained
    # - total_time_consumed
    # - balance
    # - last 3 days trend: up/down
  end
end
