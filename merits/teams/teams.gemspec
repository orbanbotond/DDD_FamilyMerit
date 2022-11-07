# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "teams"
  spec.version = "1.0.0"
  spec.authors = ["Logic Optimum"]
  spec.email = ["orbanbotond@gmail.com"]
  spec.require_paths = ["lib"]
  spec.files = Dir["lib/**/*"]
  spec.summary = "Team Handling Bounded Context"

  spec.add_dependency 'rom-sql'
  spec.add_dependency 'pg'
  spec.add_dependency 'rake'
  spec.add_dependency 'dotenv-rails'
  spec.add_dependency 'erb'
end
