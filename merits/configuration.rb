require_relative "time_harvest/lib/time_harvest"

module Merits
  class Configuration
    def initialize()
    end

    def call(cqrs)
      configure_bounded_contexts(cqrs)
      # configure_processes(cqrs)
    end

    def configure_bounded_contexts(cqrs)
      [
        TimeHarvest::Configuration.new,
      ].each { |c| c.call(cqrs) }
    end

    # def configure_processes(cqrs)
    #   Processes::Configuration.new.call(cqrs)
    # end
  end
end
