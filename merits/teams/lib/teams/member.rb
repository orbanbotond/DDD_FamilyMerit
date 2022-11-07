module Teams
  class Member
    include AggregateRoot

    def initialize(id)
      @id = id
    end

    def create(id, email)
      event = Events::MemberCreated.new(data: { id: id })
      persist_email_to_the_secondary_store(id, email)
      apply event
    end

    on Events::MemberCreated do |event|
      @id = event.data[:id]
      load_gdpr_sesitive_data_to_the_secondary_store(@id)
    end

private
    attr_reader :name, :email

    def repo
      @repo ||= DataMapper::DatabaseConnection::new(DataMapper::DatabaseConnection.connection_options).member_repo
    end

    def persist_email_to_the_secondary_store(id, email)
      repo.create(uuid: id, email: email)
    end

    def load_gdpr_sesitive_data_to_the_secondary_store(id)
      member = repo.by_id(id)
      @email = member.email
    end
  end
end