require_relative 'spec_helper'

RSpec.describe 'Event Converts' do
  include Fullfillments::TestPlumbing

  let(:id) { SecureRandom.uuid }

  describe Fullfillments::Orders::Events::Convertors::Created_V1ToV2 do
    subject(:conversion) { Fullfillments::Orders::Events::Convertors::Created_V1ToV2.new.(old_event) }

  	let(:old_event) { Fullfillments::Orders::Events::Created.new( data: { id: id } ) }

    it 'adds the default amount of 1' do
      expect(conversion.data[:amount]).to eq(1)
    end

    it 'keeps the old id' do
      expect(conversion.data[:id]).to eq(id)
    end
  end
end
