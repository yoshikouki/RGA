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

  describe '#edit, #update' do
    let(:user) { FactoryBot.create(:user) }

    it 'アカウント情報の変更ができる' do
      # ログイン
      visit root_path
      within('header') { click_on 'sign-in' }
      expect(page).to have_content 'ログイン'
      within('#sign-in-form') do
        fill_in 'form-email', with: user.email
        fill_in 'form-password', with: user.password
        click_on 'form-submit'
      end

      # アカウント情報変更
      click_on 'edit-user-registration'
      expect(page).to have_content 'アカウント情報 変更'
      within('#edit-user-registration-form') do
        fill_in 'form-email', with: 'edited@email.com'
        fill_in 'form-username', with: '変更後のユーザー名'
        fill_in 'form-new-password', with: 'editedpassword'
        fill_in 'form-new-password-confirmation', with: 'editedpassword'
        fill_in 'form-password', with: user.password
        click_on 'form-submit'
      end

      # 変更の確認
      expect(user.reload.username).to eq '変更後のユーザー名'
      expect(Player.find_by(user_id: user.id).name).to eq '変更後のユーザー名'
    end
  end
end
