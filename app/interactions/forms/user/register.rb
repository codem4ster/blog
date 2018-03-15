module Forms
  module User
    class Register < ActiveInteraction::Base
      string :username, :email, :password, :password_confirmation, :captcha

      validates :username, :password_confirmation, :captcha, :password, :email,
                presence: true
      validates :email, email: true
      validates :password, confirmation: true, length: { minimum: 6 }
      validates :captcha, captcha: true

      def execute
        if user.save
          # broadcast(:user_registered, user)
        else
          errors.merge!(user.errors)
        end
        self
      end

      private

      def user
        @user ||= ::User.new username: username, password: password, email: email
      end
    end
  end
end