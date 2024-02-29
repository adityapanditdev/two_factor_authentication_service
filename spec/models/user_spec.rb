require_relative '../spec_helper'

RSpec.describe User do
  describe 'validations' do
    it 'validates presence of email' do
      user = User.new(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: nil, password_digest: 'password123')
      expect(user.valid?).to be false
    end

    it 'validates format of email' do
      user = User.new(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: 'invalid_email', password_digest: 'password123')
      expect(user.valid?).to be false
    end

    it 'validates uniqueness of email' do
      user = User.new(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: 'test@example.com', password_digest: 'Pa@123')
      expect(user.valid?).to be false
    end

    it 'validates password complexity' do
      user = User.new(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: 'test@example.com', password_digest: 'password')
      expect(user.valid?).to be false
    end
  end

  describe '.authenticate' do
    it 'returns user if email and password match' do
      user = User.create(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: Faker::Internet.email, password: BCrypt::Password.create('Pa@123'), two_factor_enabled: false)
      authenticated_user = User.authenticate(user.email, 'Pa@123')
      expect(authenticated_user).to eq(user)
    end

    it 'returns nil if email does not exist' do
      authenticated_user = User.authenticate('nonexistent@example.com', 'password')
      expect(authenticated_user).to be_nil
    end

    it 'returns nil if password is incorrect' do
      User.create(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: Faker::Internet.email, password: BCrypt::Password.create('Pa@123'), two_factor_enabled: false)
      authenticated_user = User.authenticate('test@example.com', 'incorrect_password')
      expect(authenticated_user).to be_nil
    end
  end
end
