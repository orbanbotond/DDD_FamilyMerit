# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "processes"
  spec.version = "1.0.0"
  spec.authors = ["Logic Optimum"]
  spec.email = ["orbanbotond@gmail.com"]
  spec.require_paths = ["lib"]
  spec.files = Dir["lib/**/*"]
  spec.summary = "Process managers for the application"

  spec.add_dependency 'aggregate_root'
  spec.add_dependency 'ruby_event_store'
  spec.add_dependency 'dry-types'
  spec.add_dependency 'dry-struct'

  spec.add_dependency 'rom-sql'
  spec.add_dependency 'pg'
  spec.add_dependency 'rake'
  spec.add_dependency 'dotenv-rails'
  spec.add_dependency 'erb'
end
