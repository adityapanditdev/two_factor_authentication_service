ENV["RACK_ENV"] ||= "test"
require './config/environment'

require 'rspec'
require 'rack/test'
require 'pry'
require 'faker'
require 'database_cleaner'

RSpec.configure do |config|
  config.include Rack::Test::Methods

  # Define the Sinatra application to use for testing
  def app
    Sinatra::Application
  end

  # Configure DatabaseCleaner
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  # Reset the application before each test if needed
  config.before(:each) do
    # Add any setup code here if needed
  end

  # Add any other configuration or setup code here
end
