require_relative '../spec_helper'

RSpec.describe Processes::TeamAchievement do
  include Processes::TestPlumbing

  let(:minutes) { 1 }
  let(:team_name) { 'Family' }
  let(:activity_id) { SecureRandom.hex(16) }
  let(:user_1_id) { SecureRandom.hex(16) }
  let(:account_for_user_1_id) { user_1_id }
  let(:user_2_id) { SecureRandom.hex(16) }
  let(:account_for_user_2_id) { user_2_id }
  let(:process) { Processes::TeamAchievement.new(cqrs) }

  context 'negative cases' do
    describe 'when there is no team' do
      describe 'when the gains are twice as much as consumes' do
        it 'does not issues the AwardTeam command' do
          given( [ account_created_for(user_1_id, account_for_user_1_id),
                   time_gained_for(account_for_user_1_id, minutes * 2, activity_id),
                   time_consumed_for(account_for_user_1_id, minutes, activity_id)]).each{|event| process.(event)}


          given( [ account_created_for(user_2_id, account_for_user_2_id),
                   time_gained_for(account_for_user_2_id, minutes * 2, activity_id),
                   time_consumed_for(account_for_user_2_id, minutes, activity_id)]).each{|event| process.(event)}

          expect_nothing_have_been_commanded
        end
      end
    end

    describe 'when there is team' do
      describe 'when the gains are below twice as much as consumes' do
        it 'does not issues the AwardTeam command' do
          given( [ team_created(team_name, user_1_id, user_2_id),
                   time_gained_for(account_for_user_1_id, minutes * 2, activity_id),
                   time_consumed_for(account_for_user_1_id, minutes, activity_id)]).each{|event| process.(event)}


          given( [ account_created_for(user_2_id, account_for_user_2_id),
                   time_gained_for(account_for_user_2_id, minutes, activity_id),
                   time_consumed_for(account_for_user_2_id, minutes, activity_id)]).each{|event| process.(event)}

          expect_nothing_have_been_commanded
        end
      end
    end
  end

  describe 'when there is team' do
    describe 'when the gains are twice as much as consumes' do
      it 'issues the AwardTeam command' do
        given( [ team_created(team_name, user_1_id, user_2_id),
                 time_gained_for(account_for_user_1_id, minutes * 2, activity_id),
                 time_consumed_for(account_for_user_1_id, minutes, activity_id)]).each{|event| process.(event)}


        given( [ account_created_for(user_2_id, account_for_user_2_id),
                 time_gained_for(account_for_user_2_id, minutes * 2, activity_id),
                 time_consumed_for(account_for_user_2_id, minutes, activity_id)]).each{|event| process.(event)}

        expect_have_been_commanded(Gamification::AwardTeam.new(name: team_name))
      end
    end
  end
end
