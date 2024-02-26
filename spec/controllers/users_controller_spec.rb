require_relative '../spec_helper'

RSpec.describe 'users_controller' do
  include Rack::Test::Methods

  def app
    UsersController
  end

  describe 'POST /register' do
    it 'redirects to login' do
      post '/register', { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, password: 'Pa@123' }
      expect(User.count).to eq(1)
    end

    it 'unable to create user without valid password' do
      post '/register', { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name, email: Faker::Internet.email, password: 'password' }
      expect(User.count).to eq(0)
    end
  end

  describe 'POST /login' do
    let(:user) { User.create(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: Faker::Internet.email, password: BCrypt::Password.create('Pa@123'), two_factor_enabled: false) }
    let(:user_1) { User.create(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: Faker::Internet.email, password: BCrypt::Password.create('Pa@123'), two_factor_enabled: true) }

    context 'with valid credentials and two-factor disabled' do
      it 'redirects to account settings page' do
        post '/login', { email: user.email, password_digest: 'Pa@123' }
        expect(last_response.redirect?).to be true
        expect(URI.parse(last_response.location).path).to eq("/account/settings")
      end
    end

    context 'with valid credentials and two-factor enable' do
      it 'redirects to account settings page' do
        post '/login', { email: user_1.email, password_digest: 'Pa@123' }
        expect(last_response.redirect?).to be true
        expect(URI.parse(last_response.location).path).to eq("/setup-2fa")
      end
    end
  end

  describe 'POST /logout' do
    it 'clears the session' do
      post '/logout'
      expect(last_response).to be_redirect
      expect(URI.parse(last_response.location).path).to eq("/login")
    end
  end

  describe 'POST /account/password/update' do
    context 'when user is logged in and provides correct current password' do
      let(:user) { User.create(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: Faker::Internet.email, password: BCrypt::Password.create('Pa@123'), two_factor_enabled: false) }

      it 'updates the password and redirects to account settings page with success message' do
        post '/account/password/update', { current_password: 'Pa@123', new_password: 'Aa@123' }, 'rack.session' => { user_id: user.id }

        expect(last_response.redirect?).to be true
        expect(last_response.location).to include('/account/settings?password_updated=true')
      end
    end

    context 'when user is logged in but provides incorrect current password' do
      let(:user) { User.create(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: Faker::Internet.email, password: BCrypt::Password.create('Pa@123'), two_factor_enabled: false) }

      it 'redirects to account settings page with error message' do
        post '/account/password/update', { current_password: 'Ba@123', new_password: 'Aa@123' }, 'rack.session' => { user_id: user.id }

        expect(last_response.redirect?).to be true
        expect(last_response.location).to include('/account/settings?error=invalid_password')
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        post '/account/password/update', { current_password: 'Pa@123', new_password: 'Aa@123' }

        expect(last_response.redirect?).to be true
        expect(last_response.location).to include('/login')
      end
    end
  end
end
