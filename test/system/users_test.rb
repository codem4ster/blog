require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  test "registration" do
    visit path(:users_registration)
    fill_in 'Kullanıcı adı', with: 'seizma'
    fill_in 'E-Posta', with: 'onurelibol@gmail.com'
    fill_in 'forms_user_register_password', with: '123456'
    fill_in 'Şifre (Tekrar)', with: '123456'
    fill_in 'Güvenlik kodu', with: Session.data[:captcha]
    click_button 'Gönder'
    assert_selector 'h1', text: "Users"
  end
end
