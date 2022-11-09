require "ruby_event_store"
require "dres_rails"
require "./dres_app"
require_relative "config/application"

STDOUT.sync  = true
logger       = Logger.new(STDOUT)
logger.level = Logger::INFO

client = DresClient::Http.new(
  mapper:  RubyEventStore::Mappers::Default.new,
  uri:     URI.parse(ENV.fetch("DRES_URL")),
  api_key: ENV.fetch("DRES_API_KEY"),
)

handlers = [
  ->(event) do
    logger.info("received event: #{event}")
    if [Payments::Cards::Events::Authorized,
        Payments::Cards::Events::Captured,
        Payments::Cards::Events::Released].any? {|event_type| event.instance_of? event_type}

        logger.info("handling: #{event}")
        Fullfillment::Transaction.(event)
    end
  end
]

app = DresApp.new(
  client:    client,
  logger:    logger,
  processor: proc do |event|
    handlers.each do |handler|
      begin
        handler.(event)
      rescue => doh
        logger.error doh.backtrace
        logger.error("oh no!: #{doh.message}")
      end
    end
  end,
)

catch(:exit_now) do
  app.trap_signals
  app.run
end
