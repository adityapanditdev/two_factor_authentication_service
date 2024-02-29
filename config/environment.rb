ENV["RACK_ENV"] ||= "development"

require 'rake'
require 'pry'
require 'irb'
require 'sinatra'
require 'sinatra/flash'
require 'sinatra/activerecord'
require 'require_all'
require 'pony'
require 'bcrypt'
require 'active_record'
require 'sinatra/activerecord/rake'
require 'rotp'
require 'rqrcode'
require 'dotenv/load'
require 'sidekiq'

Dir.glob('./app/controllers/concerns/*.rb').each { |file| require file }
require_all 'app'
Dir.glob('./app/models/*.rb').each { |file| require file }

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end