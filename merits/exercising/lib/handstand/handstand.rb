module Exercising
  module Handstand
    class HandstandPractice
      include AggregateRoot

      CanSetupOnlyWhenStarted = Class.new(StandardError)
      CanHandstandOnlyAfterSetup = Class.new(StandardError)

      PROGRESSIONS = [
          {required_time: 2, required_consecutive_repetition: 3},
          {required_time: 2, required_consecutive_repetition: 5},
          {required_time: 10, required_consecutive_repetition: 5},
        ]

      def initialize(user_id)
        @user_id = user_id
        @progression = 0
        @consecutive_successfull_repetitions = 0
      end

      def progress
        event = Events::HandstandPracticeProgressed.new(data: { user_id: user_id, progression: next_progression, reason: progression_reason })
        apply event
      end

      def start_practice
        event = Events::HandstandPracticeStarted.new(data: { user_id: user_id })
        apply event
      end

      def setup(seconds)
        raise CanSetupOnlyWhenStarted.new unless state == :started

        event = if seconds > 5
          Events::HandstandSetupFailed.new(data: { user_id: user_id, time: seconds, reason: 'Too much time spent on setup' })
        else
          Events::HandstandSetupSucceeded.new(data: { user_id: user_id, time: seconds, reason: 'Setup done within 5 second limit' })
        end

        apply event
      end

      def handstand(seconds)
        raise CanHandstandOnlyAfterSetup.new unless state == :setup

        event = if enough_time_spent?(seconds)
          Events::HandstandSucceeded.new(data: { user_id: user_id, consecutive: increased_consecutive_repetitions, time: seconds, reason: 'Handstand was done for the required time' } )
        else
          Events::HandstandFailed.new(data: { user_id: user_id, time: seconds, reason: 'Handstand failed for the required time' } )
        end

        apply event
      end

      def pause
      end

      def end_practice
      end

      on Events::HandstandPracticeStarted do |event|
        @state = :started
      end

      on Events::HandstandSetupSucceeded do |event|
        setup_time = event.data[:time]
        @state = :setup
      end

      on Events::HandstandSetupFailed do |event|
        setup_time = event.data[:time]
        @state = :setup
      end

      on Events::HandstandSucceeded do |event|
        @consecutive_successfull_repetitions = event.data[:consecutive]
        progress if can_progression_be_made?
      end

      on Events::HandstandPracticeProgressed do |event|
        @progression = event.data[:progression]
      end

  private
      attr_reader :user_id, :state, :consecutive_successfull_repetitions, :progression

      def increased_consecutive_repetitions
        @consecutive_successfull_repetitions + 1
      end

      def enough_time_spent?(seconds)
        seconds > required_time
      end

      def required_time
        PROGRESSIONS[progression][:required_time]
      end

      def can_progression_be_made?
        consecutive_successfull_repetitions == PROGRESSIONS[progression][:required_consecutive_repetition]
      end

      def next_progression
        progression + 1
      end

      def progression_reason
        "#{required_consecutive_successfull_repetitions} consecutive handstands were made for #{required_time} seconds each."
      end

      def required_consecutive_successfull_repetitions
        PROGRESSIONS[progression][:required_consecutive_repetition]
      end
    end
  end
end