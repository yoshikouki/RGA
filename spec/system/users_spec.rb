require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  it '新規アカウントが作成できる' do
    visit root_path
    within('header') do
      click_on 'sign-up'
    end
    expect(page).to have_content '新規アカウント'
    within('#sign-up-form') do
      fill_in 'form-email', with: 'example@email.com'
      fill_in 'form-username', with: 'テストユーザー'
      fill_in 'form-password', with: 'password'
      fill_in 'form-password-confirmation', with: 'password'
    end
    expect { click_on 'form-submit' }.to \
      change { User.count }.from(0).to(1)
    expect(Player.first.name).to eq 'テストユーザー'
  end
end
