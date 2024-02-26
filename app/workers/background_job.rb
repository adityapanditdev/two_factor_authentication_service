# background_job.rb
require_relative '../../config/environment.rb'

class BackgroundJob
  include Sidekiq::Worker

  def perform(user_id)
    # Perform the background task here
    user = User.find_by_id(user_id)
    user.send_confirmation_email
  end
end
