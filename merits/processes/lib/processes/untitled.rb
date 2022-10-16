require 'bundler/setup'
Bundler.require

class EventStore < SimpleDelegator
  def self.in_memory
    new(
      RubyEventStore::Client.new(
        repository: RubyEventStore::InMemoryRepository.new
      )
    )
  end

  def link_event_to_stream(event, stream, expected_version: :any)
    __getobj__.link(
      event.event_id,
      stream_name: stream,
      expected_version: expected_version
    )
  end
end

event_store = EventStore.in_memory
class EventA < RubyEventStore::Event
end

class EventB < RubyEventStore::Event
end

#TODO X$specific & read from X$all
#TODO X$all & read from X$specific

stream_name = "X$#{1}"
event_store.publish(EventA.new, stream_name: stream_name)
event_store.publish(EventB.new, stream_name: stream_name)

q = event_store.read
  .stream(stream_name)
  .of_type([EventA])
q.to_a # contains EventA

q = event_store.read
  .stream('X')
  .of_type([EventA])
q.to_a # is empty

q = event_store.read
  .stream('X$all')
  .of_type([EventA])
q.to_a # is empty

stream_name = "X$all"
event_store.publish(EventA.new, stream_name: stream_name)
event_store.publish(EventB.new, stream_name: stream_name)

q = event_store.read
  .stream(stream_name)
  .of_type([EventA])
q.to_a # contains EventA

q = event_store.read
  .stream('X$3')
  .of_type([EventA])
q.to_a # empty
