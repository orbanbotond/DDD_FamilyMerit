require_relative "../../merits/configuration"
require_relative "../../merits/configuration"

class Configuration
  def call(cqrs)
    # enable_res_infra_event_linking(cqrs)

    enable_domain(cqrs)
    enable_read_models(cqrs)

    # Ecommerce::Configuration.new(
    #   number_generator: Rails.configuration.number_generator,
    #   payment_gateway: Rails.configuration.payment_gateway,
    #   available_vat_rates: [
    #     Infra::Types::VatRate.new(code: "10", rate: 10),
    #     Infra::Types::VatRate.new(code: "20", rate: 20)
    # ]
    # ).call(cqrs)
  end

  private

  # def enable_res_infra_event_linking(cqrs)
  #   [
  #     RailsEventStore::LinkByEventType.new,
  #     RailsEventStore::LinkByCorrelationId.new,
  #     RailsEventStore::LinkByCausationId.new
  #   ].each { |h| cqrs.subscribe_to_all_events(h) }
  # end

  def enable_domain(cqrs)
    Merits::Configuration.new.call(cqrs)
    Fullfillments::Configuration.new.call(cqrs)
    Payments::Configuration.new.call(cqrs)
  end

  def enable_read_models(cqrs)
    TimeHarvest::Report::Configuration.new.call(cqrs)
    Fullfillment::Transaction::Configuration.new.call(cqrs)
  end
end
