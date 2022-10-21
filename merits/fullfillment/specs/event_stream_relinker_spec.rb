require_relative 'spec_helper'

RSpec.describe 'Event Restreaming' do
  include Fullfillments::TestPlumbing

  describe 'when OrderCreated events are published' do
  	let(:event) { Fullfillments::Orders::Events::Created.new(data:{ id: id })}
    let(:id) { SecureRandom.uuid }
    let(:command_bus) { Infra::TestPlumbing::FakeCommandBus.new }

    it 'publishes the Created event' do
      expect {
				event_store.publish(event)
      }.to publish_in_stream("Fullfillments::Orders::Created", event)
    end
  end
end
