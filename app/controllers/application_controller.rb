class ApplicationController < Sinatra::Base
  include Authentication

  enable :sessions
  register Sinatra::Flash

  set :session_secret, ENV['SESSION_SECRET']
  set :views, File.expand_path('../views', __dir__)
end
