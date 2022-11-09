require 'pry-nav'
require_relative '../lib/payments.rb'

module Payments
  module TestPlumbing
    def self.included(klass)
    	klass.include Infra::TestPlumbing

      klass.send(:before, :each) do
      	Configuration.new.call(cqrs)
      end
		end
	end
end
