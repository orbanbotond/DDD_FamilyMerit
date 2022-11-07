require_relative '../spec_helper'

RSpec.describe Teams::CreateMember do
  include Teams::TestPlumbing

  describe 'command is handled properly' do
    subject(:member_created) { Teams::Events::MemberCreated.new(data: { id: id })}

    let(:id) { SecureRandom.hex(16) }
    let(:email) { 'gdpr_sensitive_email@gmail.com' }
    let(:repo) { Teams::DataMapper::DatabaseConnection::new(Teams::DataMapper::DatabaseConnection.connection_options).member_repo }
    let(:stream) { "Teams::Member$#{id}" }

    it 'publishes the TeamCreated event' do
      expect {
        run_command(Teams::CreateMember.new(id: id, email: email))
      }.to publish_in_stream(stream, member_created)

      members_created_events = event_store.read
        .stream(stream)
        .of_type([Teams::Events::MemberCreated])

      expect(members_created_events.to_a.none?{|event| event.data[:email] }).to be true
    end

    it 'saves the email to the secondary store' do
      run_command(Teams::CreateMember.new(id: id, email: email))
      expect(repo.by_id(id).email).to eq(email)
    end
  end
end
