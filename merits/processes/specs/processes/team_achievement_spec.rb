require_relative '../spec_helper'

RSpec.describe Processes::TeamAchievement do
  include Processes::TestPlumbing

  let(:minutes) { 1 }
  let(:team_name) { 'Family' }
  let(:other_team_name) { 'The_A_Team' }
  let(:activity_id) { SecureRandom.hex(16) }
  let(:the_awarded_user) { SecureRandom.hex(16) }
  let(:the_awarded_user_account) { the_awarded_user }
  let(:the_non_awarded_user_id) { SecureRandom.hex(16) }
  let(:account_for_user_2_id) { the_non_awarded_user_id }
  let(:the_only_award_missing_user) { SecureRandom.hex(16) }
  let(:the_award_missing_user_account) { the_only_award_missing_user }
  let(:process) { Processes::TeamAchievement.new(cqrs) }

  context 'negative cases' do
    describe 'when there is no team' do
      describe 'when the user is awarded' do
        it 'does not issues the AwardTeam command' do
          given( [ account_created_for(the_awarded_user, the_awarded_user_account),
                   member_awarded(the_awarded_user_account)]).each{|event| process.(event)}

          expect_nothing_have_been_commanded
        end
      end
    end

    describe 'when there is team' do
      describe 'when the gains are below twice as much as the consumes for at least one of the team members' do
        it 'does not issues the AwardTeam command' do
          given( [ team_created(team_name, the_awarded_user, the_non_awarded_user_id),
                   member_awarded(the_awarded_user_account)]).each{|event| process.(event)}

          expect_nothing_have_been_commanded
        end
      end
    end
  end

  describe 'when there is team' do
    describe 'when the gains are twice as much as consumes' do
      it 'issues the AwardTeam command' do
        given( [ team_created(team_name, the_awarded_user, the_only_award_missing_user),
                 member_awarded(the_awarded_user_account),
                 member_awarded(the_award_missing_user_account)]).each{|event| process.(event)}

        expect_have_been_commanded(Gamification::AwardTeam.new(name: team_name))
      end

      describe 'when there is a team where the only member who is missing an award has been awarded' do
        it 'awards the Team which had the unawarded team Members' do
          given( [ team_created(other_team_name, the_awarded_user, the_only_award_missing_user),
                   member_awarded(the_awarded_user_account)]).each{|event| process.(event)}

          expect_nothing_have_been_commanded

          given( [ team_created(team_name, the_only_award_missing_user, the_non_awarded_user_id),
                   member_awarded(the_award_missing_user_account)]).each{|event| process.(event)}

          expect_have_been_commanded(Gamification::AwardTeam.new(name: other_team_name))
        end
      end
    end
  end
end
