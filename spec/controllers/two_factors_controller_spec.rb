require_relative '../spec_helper'

RSpec.describe 'two_factors_controller' do
  include Rack::Test::Methods

  def app
    TwoFactorsController
  end

  describe 'POST /account/2fa' do
    context 'when user is logged in' do
      let(:user) { User.create(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: Faker::Internet.email, password_digest: BCrypt::Password.create('Pa@123'), two_factor_enabled: true) }
      before do
        allow_any_instance_of(TwoFactorsController).to receive(:current_user).and_return(user)
        allow_any_instance_of(TwoFactorsController).to receive(:session).and_return({"user_id"=>user.id, verify_token: true})
      end

      context 'when enabling 2FA' do
        it 'redirects to setup-2fa page with 2FA enabled' do
          post '/account/2fa', { enable_2fa: 'true' }

          expect(last_response.redirect?).to be true
          expect(last_response.location).to include('/setup-2fa?2fa_enabled=true')
        end
      end

      context 'when disabling 2FA' do
        let(:user) { User.create(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: Faker::Internet.email, password_digest: BCrypt::Password.create('Pa@123'), two_factor_enabled: false) }
        before do
          post '/login', { email: user.email, password_digest: 'Pa@123' }
        end
        it 'redirects to setup-2fa page with 2FA disabled' do
          post '/account/2fa', { enable_2fa: 'false' }

          expect(last_response.redirect?).to be true
          expect(last_response.location).to include('/setup-2fa?2fa_enabled=false')
        end
      end
    end

    context 'when user is not logged in' do
      it 'redirects to login page' do
        post '/account/2fa', { enable_2fa: 'true' }

        expect(last_response.redirect?).to be true
        expect(last_response.location).to include('/login')
      end
    end
  end

  describe 'POST /verify-2fa' do
    let(:user) { User.create(username: Faker::Name.first_name + ' ' + Faker::Name.last_name, email: Faker::Internet.email, password_digest: BCrypt::Password.create('Pa@123'), two_factor_enabled: true) }
    context 'when verifying 2FA' do
      it 'redirects to account settings page if token is valid' do
        allow_any_instance_of(TwoFactorsController).to receive(:current_user).and_return(user)
        allow_any_instance_of(TwoFactorsController).to receive(:session).and_return({"user_id"=>user.id})
        allow_any_instance_of(TwoFactorsController).to receive(:verify_token).and_return(true)

        post '/verify-2fa', { user_id: user.id, token: 'fake_token', fa: 'true' }

        expect(last_response.redirect?).to be true
        expect(last_response.location).to include('/account/settings')
      end

      it 'redirects to login page with error message if token is invalid' do
        allow_any_instance_of(TwoFactorsController).to receive(:current_user).and_return(user)
        allow_any_instance_of(TwoFactorsController).to receive(:session).and_return({"user_id"=>user.id})
        allow_any_instance_of(TwoFactorsController).to receive(:verify_token).and_return(false)

        post '/verify-2fa', { user_id: user.id, token: 'invalid_token', fa: 'true' }

        expect(last_response.redirect?).to be true
        expect(last_response.location).to include('/setup-2fa?error=invalid_code')
      end
    end
  end
end