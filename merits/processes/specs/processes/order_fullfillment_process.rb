require_relative 'spec_helper'

RSpec.describe Processed::OrderFullfillmentProcess do
  include Fullfillments::TestPlumbing

  let(:command_bus) { Infra::TestPlumbing::FakeCommandBus.new }
  let(:process) { Fullfillment::Process.new(cqrs) }

  let(:id) { SecureRandom.uuid }
  let(:order_created) { Fullfillments::Orders::Events::CreatedV2.new(data: {id: id}) }
  let(:deliver_order) { Fullfillments::Orders::Commands::Deliver.new(id: id, should_fail: false, failure_reason: nil) }
  let(:order_delivered) { Fullfillments::Orders::Events::Delivered.new(data: {id: id}) }
  let(:abort_order) { Fullfillments::Orders::Commands::Abort.new( id: id, reason: 'Can not authorize Card' ) }
  let(:order_aborted) { Fullfillments::Orders::Events::Delivered.new(data: {id: id, reason: 'Whatever'}) }
  let(:order_delivery_failed) { Fullfillments::Orders::Events::DeliveryFailed.new(data: {id: id, reason: 'Whatever'}) }
  let(:manual_investigate) { Fullfillments::Orders::Commands::ManualInvestigate.new( {id: id}) }

  let(:authorize_payment) { Payments::Cards::Commands::Authorize.new( id: id ) }
  let(:payment_authorized) { Payments::Cards::Events::Authorized.new(data: { id: id}) }
  let(:payment_authorization_failed) { Payments::Cards::Events::AuthorizationFailed.new(data: { id: id, reason: 'whatever'}) }
  let(:capture_payment) { Payments::Cards::Commands::Capture.new( id: id ) }
  let(:payment_captured) { Payments::Cards::Events::Captured.new( data: { id: id} ) }
  let(:payment_capture_failed) { Payments::Cards::Events::CaptureFailed.new( data: { id: id, reason: 'Whatever'} ) }
  let(:release_payment) { Payments::Cards::Commands::Release.new( id: id ) }
  let(:release_payment_failed) { Payments::Cards::Events::ReleaseFailed.new( data: { id: id, reason: 'Whatever' } ) }
  let(:payment_released) { Payments::Cards::Events::Released.new( data: { id: id } ) }

  context 'when order_created' do
    it 'issues Payment::Authorize' do
      process_events([order_created], process: process)
      expect_have_been_commanded(authorize_payment)
    end

    context 'when payment_authorization succeded' do
      it 'can issue Order::Deliver' do
        process_events([order_created,
                        payment_authorized], 
                        process: process)

        expect_have_been_commanded(deliver_order)
      end

      context 'when Order::Delivered' do
        it 'issues Payment::Capture' do
          process_events([order_created,
                          payment_authorized,
                          order_delivered], 
                          process: process)

          expect_have_been_commanded(capture_payment)
        end

        context 'when Payment::CaptureSucceeded' do
          it 'links the event' do
            expect {
              process_events([order_created,
                              payment_authorized,
                              order_delivered,
                              payment_captured],
                              process: process)
            }.to publish_in_stream("Fullfillments::Payment::Captured", payment_captured)
          end
        end
        context 'when Payment::CaptureFailed' do
          it 'manual investigate' do
            expect {
              process_events([order_created,
                              payment_authorized,
                              order_delivered,
                              payment_capture_failed], 
                              process: process)
            }.to publish_in_stream("Fullfillments::Payment::CaptureFailed", payment_capture_failed)

            expect_have_been_commanded(manual_investigate)
          end
        end
      end

      it 'can issue Order::FailToDeliver'
      context 'when Order::FailToDelivered' do
        it 'issues Payment::Release' do
            process_events([order_created,
                            payment_authorized,
                            order_delivery_failed], 
                            process: process)

            expect_have_been_commanded(release_payment)
        end

        context 'when Payment::ReleaseFailed' do
          it 'issues ManualInvestigate' do
            process_events([order_created,
                            payment_authorized,
                            order_delivery_failed,
                            release_payment_failed],
                            process: process)

            expect_have_been_commanded(manual_investigate)
          end
        end
        context 'when Payment::ReleaseSucceeded' do
          it 'link the event' do
            expect {
              process_events([order_created,
                              payment_authorized,
                              order_delivery_failed,
                              payment_released],
                              process: process)
            }.to publish_in_stream("Fullfillments::Payment::Released", payment_released)
          end
        end
      end
    end
    context 'when payment_authorization failed' do
      it 'issues Order::Abort' do
        process_events([order_created,
                        payment_authorization_failed], 
                        process: process)

        expect_have_been_commanded(abort_order)
      end
    end
  end
end
