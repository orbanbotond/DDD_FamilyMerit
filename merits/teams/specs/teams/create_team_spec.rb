require_relative '../spec_helper'

RSpec.describe Teams::CreateTeam do
  include Teams::TestPlumbing

  describe 'command is handled properly' do
    subject(:team_created) { Teams::Events::TeamCreated.new(data: team_data )}

    let(:team_name) { 'Family' }
    let(:team_data) { { name: team_name,
                        members: [{ user_id: user_1_id },
                                  { user_id: user_2_id }]} }

    let(:user_1_id) { SecureRandom.hex(16) }
    let(:user_2_id) { SecureRandom.hex(16) }

    it 'publishes the TeamCreated event' do
      expect {
        run_command(Teams::CreateTeam.new(team_data))
      }.to publish_in_stream("Teams::Formation$#{team_name}", team_created)
    end
  end
end
