module Teams
  class Formation
    include MyAggregateRoot

    def initialize(name)
      @name = name
    end

    def create(name, member_ids)
      event = Events::TeamCreated.new(data: { name: name, members: member_ids})
      apply event
    end

    on Events::TeamCreated do |event|
      @member_ids = event.data[:members].map{|x|x[:user_id]}
    end

private
    attr_reader :name, :member_ids
  end
end