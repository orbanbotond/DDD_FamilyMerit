require_relative '../spec_helper'
require 'securerandom'

RSpec.describe TimeHarvest::Account do
	describe 'create the account' do
		let(:account_id) { SecureRandom.hex(16) }
		let(:user_id) { SecureRandom.hex(16) }

		it 'publishes the AccountCreated event' do
			account = described_class.new(account_id)
      account.create_for(user_id)

      expect(account.unpublished_events.map(&:data)).to eq([
          TimeHarvest::Events::AccountCreatedForUser.new(
            data: { user_id: user_id, account_id: account_id }
          )
        ].map(&:data))
    end
	end

	describe 'consumes the accumulated time' do
		let(:account_id) { SecureRandom.hex(16) }
		let(:activity_id) { SecureRandom.hex(16) }
		let(:minutes) { 5 }

		context 'negative cases' do
			describe 'nil parameters' do
				it 'throws an error when the time is nil' do
					minutes = nil
					account = described_class.new(account_id)
					expect{account.consume_time(minutes, activity_id)}.to raise_error(TimeHarvest::Account::ArgumentIsNil)
				end

				it 'throws an error when the activity is nil' do
					minutes = 1
					activity_id = nil
					account = described_class.new(account_id)
					expect{account.consume_time(minutes, activity_id)}.to raise_error(TimeHarvest::Account::ArgumentIsNil)
				end
			end

			it 'throws an error when the time is 0' do
				minutes = 0
				account = described_class.new(account_id)
				expect{account.consume_time(minutes, activity_id)}.to raise_error(TimeHarvest::Account::MinutesAreNotPositive)
			end

			it 'throws an error when the time is negative' do
				minutes = -1
				account = described_class.new(account_id)
				expect{account.consume_time(minutes, activity_id)}.to raise_error(TimeHarvest::Account::MinutesAreNotPositive)
			end

			it 'throws an error when the activity does not exists'
		end

		it 'publishes the TimeConsumedOnActivity event' do
			minutes = 5
			account = described_class.new(account_id)
      account.consume_time(minutes, activity_id)

      expect(account.unpublished_events.map(&:data)).to eq([
          TimeHarvest::Events::TimeConsumedOnActivity.new(
            data: { activity_id: activity_id,
            				account_id: account_id,
				            minutes: minutes }
          )
        ].map(&:data))
    end
	end

	describe 'gain time on an activity' do
		let(:account_id) { SecureRandom.hex(16) }
		let(:activity_id) { SecureRandom.hex(16) }
		let(:minutes) { 5 }

		context 'negative cases' do
			describe 'nil parameters' do
				it 'throws an error when the time is nil' do
					minutes = nil
					account = described_class.new(account_id)
					expect{account.gain_time(minutes, activity_id)}.to raise_error(TimeHarvest::Account::ArgumentIsNil)
				end

				it 'throws an error when the activity is nil' do
					activity_id = nil
					account = described_class.new(account_id)
					expect{account.gain_time(minutes, activity_id)}.to raise_error(TimeHarvest::Account::ArgumentIsNil)
				end
			end

			it 'throws an error when the time is 0' do
				minutes = 0
				account = described_class.new(account_id)
				expect{account.gain_time(minutes, activity_id)}.to raise_error(TimeHarvest::Account::MinutesAreNotPositive)
			end

			it 'throws an error when the time is negative' do
				minutes = -1
				account = described_class.new(account_id)
				expect{account.gain_time(minutes, activity_id)}.to raise_error(TimeHarvest::Account::MinutesAreNotPositive)
			end

			it 'throws an error when the activity does not exists'
		end

		it 'publishes the TimeSpentOnActivity event' do
			account = described_class.new(account_id)
      account.gain_time(minutes, activity_id)

      expect(account.unpublished_events.map(&:data)).to eq([
          TimeHarvest::Events::TimeGainedOnActivity.new(
            data: { activity_id: activity_id,
				            minutes: minutes,
				            account_id: account_id }
          )
        ].map(&:data))
    end
	end
end