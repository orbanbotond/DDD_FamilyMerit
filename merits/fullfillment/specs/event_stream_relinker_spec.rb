require_relative 'spec_helper'

RSpec.describe 'Event Restreaming' do
  include Fullfillments::TestPlumbing

  describe 'when OrderCreated event is published' do
  	let(:event) { Fullfillments::Orders::Events::Created.new(data:{ id: id })}
    let(:id) { SecureRandom.uuid }
    let(:command_bus) { Infra::TestPlumbing::FakeCommandBus.new }

    it 'publishes the Created event' do
      expect {
				event_store.publish(event)
      }.to publish_in_stream("Fullfillments::Orders::Created", event)
    end
  end

  describe 'when OrderCreatedV2 event is published' do
    let(:event) { Fullfillments::Orders::Events::CreatedV2.new(data:{ id: id, amount: 2 })}
    let(:id) { SecureRandom.uuid }
    let(:command_bus) { Infra::TestPlumbing::FakeCommandBus.new }

    it 'publishes the Created event' do
      expect {
        event_store.publish(event)
      }.to publish_in_stream("Fullfillments::Orders::Created", event)
    end
  end
end
