module Authentication

  def current_user
    @user = User.find_by_id(session[:user_id])
  end

  # Method to require user login
  def require_login
    redirect '/login?error=session_expired' if current_user.nil?
  end

  def is_token_verified
    redirect '/setup-2fa?error=2fa_not_completed' if session[:verify_token] != true
  end

  def create_user_and_send_confirmation_email(user_info, user)
    encrypted_password = BCrypt::Password.create(user_info[:password])
    user.password = encrypted_password
    return true if user.save && BackgroundJob.perform_async(user.id)
  end

  # Method to generate a secret key for 2FA
  def generate_secret
    current_user.update(token: ROTP::Base32.random_base32) if current_user.token.nil?
  end

  # Method to generate a QR code URL for the secret key
  def generate_qr_code_url(secret, username)
    issuer = 'two_factor_authentication' # Customize issuer if needed
    ROTP::TOTP.new(secret, issuer: issuer).provisioning_uri(username)
  end

  # Method to verify the token entered by the user
  def verify_token(secret, token)
    totp = ROTP::TOTP.new(secret)
    totp.verify(token)
  end
end
