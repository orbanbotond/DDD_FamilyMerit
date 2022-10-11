require_relative '../lib/time_harvest'

module TimeHarvest
  module TestPlumbing
    def self.included(klass)
    	klass.include Infra::TestPlumbing

      klass.send(:before, :each) do
      	Configuration.new.call(cqrs)
      end
		end
	end
end