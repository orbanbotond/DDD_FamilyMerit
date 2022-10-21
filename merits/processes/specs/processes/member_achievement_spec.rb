require_relative '../spec_helper'

RSpec.describe Processes::MemberAchievement do
  include Processes::TestPlumbing

  let(:minutes) { 1 }
  let(:activity_id) { SecureRandom.hex(16) }
  let(:user_1_id) { SecureRandom.hex(16) }
  let(:account_for_user_1_id) { user_1_id }
  let(:process) { Processes::MemberAchievement.new(cqrs) }

  context 'negative cases' do
    describe 'when the gains are below twice as much as the consumes' do
      it 'does not issues the AwardMember command' do
        process_events( [ time_gained_for(account_for_user_1_id, minutes * 3, activity_id),
                          time_consumed_for(account_for_user_1_id, minutes * 2, activity_id)], 
                          process: process)

        expect_nothing_have_been_commanded
      end
    end
  end

  describe 'when the gains are twice as much as consumes' do
    it 'issues the AwardMember command' do
      process_events( [ time_gained_for(account_for_user_1_id, minutes * 2, activity_id),
               time_consumed_for(account_for_user_1_id, minutes, activity_id)],
               process: process)

      expect_have_been_commanded(Gamification::AwardMember.new(user_id: account_for_user_1_id))
    end
  end
end
