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
end
