class TwoFactorsController < ApplicationController

  before '/setup-2fa' do
    require_login
  end
  
  before '/verify-2fa' do
    require_login
  end

  post '/account/2fa' do
    enable_2fa = params['enable_2fa'] == 'true'

    if params['enable_2fa'] == 'true'
      generate_secret
      redirect '/setup-2fa?2fa_enabled=true'
    else
      redirect "/setup-2fa?2fa_enabled=false"
    end
    redirect "/account/settings?2fa_enabled=true"
  end

  get '/setup-2fa' do
    @secret = current_user.token
    qr_code_url = generate_qr_code_url(@secret, current_user.email)
    qr = RQRCode::QRCode.new(qr_code_url)
    svg = qr.as_svg(module_size: 3)
    @encoded_svg = Base64.strict_encode64(svg)
    erb :setup_2fa
  end

  post '/verify-2fa' do
    secret = current_user.token
    token = params[:token]

    if verify_token(secret, token)
      current_user.update(two_factor_enabled: params[:fa]) if params[:fa].present?
      session[:verify_token] = true
      session[:user_id] = current_user.id
      redirect '/account/settings'
    else
      redirect '/setup-2fa?error=invalid_code'
    end
  end
end
