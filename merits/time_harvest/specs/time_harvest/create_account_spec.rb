require_relative '../spec_helper'

RSpec.describe TimeHarvest::CreateAccount do
  include TimeHarvest::TestPlumbing

  describe 'command is handled properly' do
    subject(:account_created_for_client) { TimeHarvest::Events::AccountCreatedForUser.new(data: { user_id: user_id, account_id: new_account_id }) }

    let(:new_account_id) { SecureRandom.hex(16) }
    let(:user_id) { SecureRandom.hex(16) }

    it 'publishes the AccountCreated event' do
      run_command(TimeHarvest::CreateAccount.new(user_id: user_id, account_id: new_account_id))

      expect(account_created_for_client).to be_published_in_stream("TimeHarvest::Account$#{new_account_id}")

      expect {
        run_command(TimeHarvest::CreateAccount.new(user_id: user_id, account_id: new_account_id))
      }.to publish_in_stream("TimeHarvest::Account$#{new_account_id}", account_created_for_client)
    end
  end
end
