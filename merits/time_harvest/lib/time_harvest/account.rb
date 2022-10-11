module TimeHarvest
  class Account
    include AggregateRoot

    MinutesAreNotPositive = Class.new(StandardError)
    ArgumentIsNil = Class.new(StandardError)

    attr_reader :time_credit, :history

    def initialize(account_id)
      @account_id = account_id
      @time_credit = 0
      @user_id = nil
      @history = []
    end

    def create_for(user_id)
      guard_against_nil(user_id)

      event = Events::AccountCreatedForUser.new(data: { user_id: user_id, account_id: @account_id })
      apply event 
    end

    def consume_time(minutes, activity_id)
      guard_against_invalid_params(minutes, activity_id)

      apply Events::TimeConsumedOnActivity.new(data: { minutes: minutes, activity_id: activity_id, account_id: @account_id})
    end

    def gain_time(minutes, activity_id)
      guard_against_invalid_params(minutes, activity_id)

      apply Events::TimeGainedOnActivity.new(data: { minutes: minutes, activity_id: activity_id})
    end

    private
      def guard_against_invalid_params(minutes, activity_id)
        guard_against_nil(minutes)
        guard_against_nil(activity_id)
        guard_the_positivity_of_minutes(minutes)
      end

      def guard_against_nil(arg)
        raise ArgumentIsNil if arg.nil?
      end

      def guard_the_positivity_of_minutes(minutes)
        raise MinutesAreNotPositive unless minutes > 0
      end

      on Events::TimeGainedOnActivity do |event|
        @time_credit += event.data[:minutes]
        @history << event.data
      end

      on Events::TimeConsumedOnActivity do |event|
        @time_credit -= event.data[:minutes]
        @history << event.data
      end

      on Events::AccountCreatedForUser do |event|
      # on Events::AccountCreatedForUser do |event|
        @user_id = event.data[:user_id]
      end
  end
end
