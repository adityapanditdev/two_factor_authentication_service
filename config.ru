require './config/environment'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  puts 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride

class Router < Sinatra::Base
  use ApplicationController
  use UsersController
  use TwoFactorsController
end

run Router
# system('nohup redis-server &')
# system('nohup bundle exec sidekiq -r ./config/environment.rb &')
