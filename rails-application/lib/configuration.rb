require_relative "../../merits/configuration"
require_relative "../../merits/configuration"

class Configuration
  def call(cqrs)
    enable_domain(cqrs)
    enable_read_models(cqrs)
  end

  private

  def enable_domain(cqrs)
    Merits::Configuration.new.call(cqrs)
    Fullfillments::Configuration.new.call(cqrs)
    Payments::Configuration.new.call(cqrs)
  end

  def enable_read_models(cqrs)
    TimeHarvest::Report::Configuration.new.call(cqrs)
    Fullfillment::Transaction::Configuration.new.call(cqrs)
    Fullfillment::Order::Configuration.new.call(cqrs)
  end
end
