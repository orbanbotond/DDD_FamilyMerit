require_relative '../spec_helper'

RSpec.describe TimeHarvest::GainTime do
  include TimeHarvest::TestPlumbing

  describe 'command is handled properly' do
    subject(:time_gained_for_account) { TimeHarvest::Events::TimeGainedOnActivity.new(data: { account_id: account_id, minutes: minutes, activity_id: activity_id}) }

    let(:minutes) { 1 }
    let(:account_id) { SecureRandom.hex(16) }
    let(:activity_id) { SecureRandom.hex(16) }
    let(:user_id) { SecureRandom.hex(16) }

    it 'publishes the TimeGained event' do
      run_command(TimeHarvest::CreateAccount.new(user_id: user_id, account_id: account_id))

      expect {
        run_command(TimeHarvest::GainTime.new(account_id: account_id, minutes: minutes, activity_id: activity_id))
      }.to publish_in_stream("TimeHarvest::Account$#{account_id}", time_gained_for_account)
    end
  end
end
