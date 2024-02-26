class UsersController < ApplicationController

  get '/' do
    erb :register, locals: { errors: [] }
  end

  post '/register' do
    user = User.new(username: params['first_name'] + ' ' + params['last_name'], email: params['email'], password: params['password'])
    
    if user.valid? && create_user_and_send_confirmation_email(params, user)
      redirect '/login'
    else    
      erb :register, locals: { errors: user.errors.full_messages }
    end
  end

  get '/login' do
    erb :login, locals: { error: params['error'].to_s }
  end

  post '/login' do
    user = User.authenticate(params['email'], params['password_digest'])
    if user
      session[:user_id] = user.id
      redirect user.two_factor_enabled ? "/setup-2fa" : "/account/settings"
    else
      flash[:error] = "Invalid email or password."
      redirect '/login'
    end
  end

  post '/logout' do
    session.clear if current_user
    flash[:message] = "Logout Successfully"
    redirect '/login'
  end
end
