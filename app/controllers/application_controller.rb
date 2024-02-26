class ApplicationController < Sinatra::Base
  include Authentication

  enable :sessions
  register Sinatra::Flash

  set :session_secret, ENV['SESSION_SECRET']
  set :views, File.expand_path('../views', __dir__)

  before '/account/*' do
    is_token_verified if current_user&.two_factor_enabled
    require_login
  end
end
