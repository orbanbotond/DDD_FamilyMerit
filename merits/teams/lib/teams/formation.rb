module Teams
  class Formation
    include MyAggregateRoot

    def create(name, member_ids)
      event = Events::TeamCreated.new(data: { name: name, members: member_ids})
      publish event
    end

    on Events::TeamCreated do |event|
      @member_ids = event.data[:members].map{|x|x[:user_id]}
    end
  end
end