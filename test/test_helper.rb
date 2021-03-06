require 'simplecov'

SimpleCov.start 'rails' do
  coverage_dir 'tmp/coverage'
  add_filter '/bundle/'
  add_group 'Decorators', 'app/decorators'
  add_group 'Serializers', 'app/serializers'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

FactoryBot::SyntaxRunner.class_eval do
  include ActionDispatch::TestProcess
end

class ActiveSupport::TestCase
  fixtures :all
  include FactoryBot::Syntax::Methods
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def json_response
    MultiJson.load(@response.body, symbolize_keys: true)
  end
end
