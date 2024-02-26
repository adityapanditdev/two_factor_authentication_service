class User < ApplicationRecord
  # Validations
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }
  validate :password_complexity

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    return nil unless user
    if BCrypt::Password.new(user.password) == password
      return user
    else
      return nil
    end
  end

  def send_confirmation_email
    Pony.mail({
      to: email,
      subject: 'Registration Confirmation',
      body: 'Thank you for registering!',
      via: :smtp,
      via_options: {
        address: 'smtp.gmail.com',
        port: '587',
        user_name: 'rordev123456@gmail.com',
        password: 'ktmdrloqmibaxknl',
        authentication: :plain,
        domain: 'gmail.com',
        timeout: 120
      }
    })
  end

  private

  def password_complexity
    return if password.blank?

    unless password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\p{P}\p{S}])[A-Za-z\d\p{P}\p{S}]{6,}$/)
      errors.add :password, 'must include at least one lowercase letter, one uppercase letter, one digit, one special character, and be at least 6 characters long'
    end
  end
end
