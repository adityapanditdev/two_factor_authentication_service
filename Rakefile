require_relative './config/environment'

Rake::Task['db:migrate'].enhance [:environment] do
  ActiveRecord::Tasks::DatabaseTasks.migrate(env: 'test')
end

desc 'Starts a console with access to your application environment'
task :console do
  puts 'Loading application environment...'

  puts 'Starting console...'
  sh 'irb -r ./config/environment'
end
