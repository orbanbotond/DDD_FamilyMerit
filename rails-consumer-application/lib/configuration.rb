class Configuration
  def call(cqrs)
    enable_read_models(cqrs)
  end

  private

  def enable_read_models(cqrs)
    Fullfillment::Transaction::Configuration.new.call(cqrs)
  end
end
