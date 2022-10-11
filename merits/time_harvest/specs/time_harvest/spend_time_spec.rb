require_relative '../spec_helper'

RSpec.describe TimeHarvest::CreateAccount do
  include TimeHarvest::TestPlumbing

  describe 'command is handled properly' do
    subject(:time_consumed_for_client) { TimeHarvest::Events::TimeConsumedOnActivity.new(data: { account_id: account_id, minutes: minutes, activity_id: activity_id}) }

    let(:minutes) { 1 }
    let(:account_id) { SecureRandom.hex(16) }
    let(:activity_id) { SecureRandom.hex(16) }
    let(:user_id) { SecureRandom.hex(16) }

    it 'publishes the AccountCreated event' do
      run_command(TimeHarvest::CreateAccount.new(user_id: user_id, account_id: account_id))

      expect {
        run_command(TimeHarvest::ConsumeTime.new(account_id: account_id, minutes: minutes, activity_id: activity_id))
      }.to publish_in_stream("TimeHarvest::Account$#{account_id}", time_consumed_for_client)
    end
  end
end
