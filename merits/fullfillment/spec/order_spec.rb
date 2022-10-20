require_relative 'spec_helper'

RSpec.describe Fullfillments::Order do
  include Fullfillments::TestPlumbing

  describe 'commands are handled properly' do
    let(:create) { Fullfillments::Orders::Commands::Create.new(id: id) }
    let(:id) { SecureRandom.uuid }
    let(:deliver) { Fullfillments::Orders::Commands::Deliver.new(id: id, should_fail: false, failure_reason: nil) }
    let(:dont_deliver) { Fullfillments::Orders::Commands::Deliver.new(id: id, should_fail: true, failure_reason: failure_reson) }
    let(:abort) { Fullfillments::Orders::Commands::Abort.new(id: id, reason: reason) }

    describe 'create' do
      subject(:event) { Fullfillments::Orders::Events::Created.new( data: { id: id } )}
      

      let(:data) { { id: id } }

      it 'publishes the Created event' do
        expect {
          run_command(create)
        }.to publish_in_stream("Fullfillments::Order$#{id}", event)
      end

      describe 'cant create twice' do
        it 'trows exception' do
          run_commands(create)

          expect { run_command(create) }.to raise_error(Fullfillments::Order::AlreadyCreated)
        end
      end
    end

    describe 'deliver' do
      describe 'can only do after creation' do
        it 'trows exception' do
          expect { run_command(deliver) }.to raise_error(Fullfillments::Order::CanDeliverOnlyAfterCreation)
        end
      end

      context 'when decides to not deliver' do
        subject(:event) { Fullfillments::Orders::Events::DeliveryFailed.new( data: { id: id, reason: failure_reson } )}
        let(:failure_reson) { 'Could not deliver' }

        it 'publishes the DeliveryFailed event' do
          run_commands(create)

          expect {
            run_command(dont_deliver)
          }.to publish_in_stream("Fullfillments::Order$#{id}", event)
        end
      end

      context 'when succeeds to deliver' do
        subject(:event) { Fullfillments::Orders::Events::Delivered.new( data: { id: id } )}
        

        let(:data) { { id: id, should_fail: false } }

        it 'publishes the Delivered event' do
          run_commands(create)

          expect {
            run_command(Fullfillments::Orders::Commands::Deliver.new(id: id, should_fail: false, failure_reason: nil))
          }.to publish_in_stream("Fullfillments::Order$#{id}", event)
        end
      end
    end

    describe 'abort' do
      describe 'can only do after creation' do
        it 'trows exception' do
          expect { run_command(abort) }.to raise_error(Fullfillments::Order::CanAbortOnlyAfterCreation)
        end
      end

      subject(:event) { Fullfillments::Orders::Events::Aborted.new( data: { id: id, reason: reason } )}
      
      let(:reason) { 'Intentional' }

      let(:data) { { id: id } }

      it 'creates the Aborted event' do
        run_commands(create)

        expect {
          run_command(abort)
        }.to publish_in_stream("Fullfillments::Order$#{id}", event)
      end
    end
  end
end
