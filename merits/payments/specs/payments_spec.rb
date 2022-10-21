require_relative 'spec_helper'

RSpec.describe Payments do
  include Payments::TestPlumbing

  describe 'when handling commands' do
    let(:authorize) { Payments::Cards::Commands::Authorize.new(id: id) }
    let(:id) { SecureRandom.uuid }
    let(:capture) { Payments::Cards::Commands::Capture.new(id: id) }
    let(:release) { Payments::Cards::Commands::Release.new(id: id) }

    describe 'when authorize' do
      context 'when authorization succeeds' do

        subject(:event) { Payments::Cards::Events::Authorized.new( data: data )}
        
        let(:data) { { id: id } }

        it 'publishes the Created event' do
          expect {
            run_command(authorize)
          }.to publish_in_stream("Payments::Card$#{id}", event)
        end
      end

      context 'when authorization fails' do
        subject(:event) { Payments::Cards::Events::AuthorizationFailed.new( data: { id: id, reason: failure_reason } )}
        let(:failure_reason) { 'Whatever' }

        it 'publishes the AuthorizationFailed event' do
          allow_any_instance_of(Payments::Gateway).to receive(:success?).and_return(false)

          expect {
            run_command(authorize)
          }.to publish_in_stream("Payments::Card$#{id}", event)
        end
      end
    end

    describe 'capture' do
      describe 'can only do after authorization' do
        it 'throws exception' do
          expect { run_command(capture) }.to raise_error(Payments::Card::CanCaptureOnlyAfterAuthorization)
        end
      end

      context 'when capture fails' do
        subject(:event) { Payments::Cards::Events::CaptureFailed.new( data: { id: id, reason: failure_reason } )}
        let(:failure_reason) { 'Whatever' }

        it 'publishes the CaptureFailed event' do
          run_commands(authorize)

          allow_any_instance_of(Payments::Gateway).to receive(:success?).and_return(false)

          expect {
            run_command(capture)
          }.to publish_in_stream("Payments::Card$#{id}", event)
        end
      end

      context 'when succeeds to capture' do
        subject(:event) { Payments::Cards::Events::Captured.new( data: { id: id } )}

        it 'publishes the Delivered event' do
          run_commands(authorize)

          expect {
            run_command(capture)
          }.to publish_in_stream("Payments::Card$#{id}", event)
        end
      end
    end

    describe 'release' do
      describe 'can only do after authorization' do
        it 'throws exception' do
          expect { run_command(release) }.to raise_error(Payments::Card::CanReleaseOnlyAfterAuthorization)
        end
      end

      context 'when the release succeedes' do
        subject(:event) { Payments::Cards::Events::Released.new( data: { id: id } )}

        it 'creates the Released event' do
          run_commands(authorize)

          expect {
            run_command(release)
          }.to publish_in_stream("Payments::Card$#{id}", event)
        end
      end

      context 'when the release fails' do
        subject(:event) { Payments::Cards::Events::ReleaseFailed.new( data: { id: id, reason: failure_reason } )}

        let(:failure_reason) { 'Whatever' }

        it 'creates the ReleaseSucceeded event' do
          run_commands(authorize)

          allow_any_instance_of(Payments::Gateway).to receive(:success?).and_return(false)

          expect {
            run_command(release)
          }.to publish_in_stream("Payments::Card$#{id}", event)
        end
      end
    end
  end
end
