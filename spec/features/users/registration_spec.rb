require 'rails_helper'

RSpec.feature "Registrations", type: :feature do
  let(:user) { build(:user, account_name: "test",
                            email: "test@example.org",
                            password: "abcdefg",
                            password_confirmation: "abcdefg") }
  before do
    visit signup_path
  end

  scenario "ユーザー登録に失敗しエラー情報を返す" do
    within ".registration-form" do
      fill_in "user_account_name", with: ""
      fill_in "user_email", with: "user@invalid"
      fill_in "user_password", with: "foo"
      fill_in "user_password_confirmation", with: "bar"
      check "利用規約に同意する"
      click_button "Create Account"
    end
    expect(page).to have_css "div#error_explanation"
  end

  scenario "ユーザー登録に成功する" do
    expect {
      within ".registration-form" do
        fill_in "user_account_name", with: user.account_name
        fill_in "user_email", with: user.email
        fill_in "user_password", with: user.password
        fill_in "user_password_confirmation", with: user.password_confirmation
        check "利用規約に同意する"
        click_button "Create Account"
      end
      expect(page).to have_content "アカウント登録が完了しました。"
      expect(current_path).to eq root_path
    }.to change(User, :count).to(1)
  end
end
