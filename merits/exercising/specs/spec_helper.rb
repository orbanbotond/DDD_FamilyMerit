ENV['ENVIRONMENT'] = 'test'

require_relative '../lib/exercising.rb'
require 'pry-nav'

module Exercising
  module TestPlumbing
    def self.included(klass)
    	klass.include Infra::TestPlumbing

      klass.send(:before, :each) do
      	Configuration.new.call(cqrs)
      end
		end
	end
end
