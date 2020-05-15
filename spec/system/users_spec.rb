require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  describe '#new, #create' do
    let(:user) { FactoryBot.build(:user) }

    it '新規アカウントが作成できる' do
      visit root_path
      within('header') { click_on 'sign-up' }
      expect(page).to have_content '新規アカウント'
      within('#sign-up-form') do
        fill_in 'form-email', with: user.email
        fill_in 'form-username', with: user.username
        fill_in 'form-password', with: user.password
        fill_in 'form-password-confirmation', with: user.password
      end
      expect { click_on 'form-submit' }.to \
        change { User.count }.by(1)
      expect(Player.first.name).to eq user.username
    end
    end
  end
end
