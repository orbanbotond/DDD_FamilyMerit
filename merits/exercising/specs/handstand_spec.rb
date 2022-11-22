require_relative './spec_helper'

RSpec.describe 'Handstand' do
  include Exercising::TestPlumbing

  let(:start_practicing) {Exercising::Handstand::Commands::StartHandstandPractice.new(user_id: user_id)}
  let(:setup) { Exercising::Handstand::Commands::RecordHandstandSetupTime.new(user_id: user_id, seconds: setup_time)}
  let(:setup_time) { 5 }

  let(:user_id) { SecureRandom.hex(16) }
  let(:stream) { "Exercising::Handstand::HandstandPractice$#{user_id}" }

  describe 'start_practice' do
    subject(:practice_started) { Exercising::Handstand::Events::HandstandPracticeStarted.new(data: { user_id: user_id })}

    it 'publishes the TeamCreated event' do
      expect {
        run_command(start_practicing)
      }.to publish_in_stream(stream, practice_started)
    end
  end

  describe 'setup' do
    context 'when the setup time is more than 5 seconds' do
      subject(:setup_failed) { Exercising::Handstand::Events::HandstandSetupFailed.new(data: { user_id: user_id, time: setup_time, reason: 'Too much time spent on setup' })}

      let(:setup_time) { 6 }

      it 'publishes the SetupFailed event' do
        run_commands(start_practicing)

        expect {
          run_command(setup)
        }.to publish_in_stream(stream, setup_failed)
      end
    end

    context 'when the setup time is less or equal than 5 seconds' do
      subject(:setup_succeeded) { Exercising::Handstand::Events::HandstandSetupSucceeded.new(data: { user_id: user_id, time: setup_time, reason: 'Setup done within 5 second limit' }) }

      it 'publishes the HandstandSetupSucceeded event' do
        run_commands(start_practicing)

        expect {
          run_command(setup)
        }.to publish_in_stream(stream, setup_succeeded)
      end
    end
  end

  describe 'handstand' do
    let(:do_handstand) { Exercising::Handstand::Commands::RecordHandstandTime.new(user_id: user_id, seconds: handstand_time) }
    let(:handstand_done) { Exercising::Handstand::Events::HandstandSucceeded.new(data: { user_id: user_id, time: handstand_time, reason: 'Handstand was done for the required time', consecutive: consecutive }) }
    let(:consecutive) { 1 }

    context 'when the handstand is equal or more than the required in the progression' do
      subject(:handstand) { handstand_done }

      let(:handstand_time) { 12 }

      it 'publishes the HandstandSetupSucceeded event' do
        run_commands(start_practicing)
        run_commands(setup)

        expect {
          run_command(do_handstand)
        }.to publish_in_stream(stream, handstand)
      end

      context 'when consequtively succeed with the handstand' do
        let(:consecutive) { 2 }

        let(:handstand_time) { 12 }

        it 'publishes the HandstandSetupSucceeded event' do
          run_commands(start_practicing)
          run_commands(setup)
          run_commands(do_handstand)

          expect {
            run_command(do_handstand)
          }.to publish_in_stream(stream, handstand_done)
        end
      end

      context 'when do enough handstands to consider a progression' do
        subject(:handstand_progress) { Exercising::Handstand::Events::HandstandPracticeProgressed.new(data: { user_id: user_id, reason: "#{3} consecutive handstands were made for #{2} seconds each.", progression: 1 })}
        let(:consecutive) { 3 }
        let(:handstand_time) { 12 }

        it 'publishes the HandstandSetupSucceeded event' do
          run_commands(start_practicing)
          run_commands(setup)
          run_commands(do_handstand)
          run_commands(do_handstand)

          expect {
            run_command(do_handstand)
          }.to publish_in_stream(stream, handstand_done, handstand_progress)
        end
      end

    end

    context 'when the handstand is less than the required in the progression' do
    end
  end
end
