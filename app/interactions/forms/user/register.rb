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
        if site_user.save
          broadcast(:site_user_registered, site_user)
        else
          errors.merge!(site_user.errors)
        end
        self
      end

      def to_model
        self
      end

      private

      def site_user
        @site_user ||= SiteUser.new username: username, password: password,
                                    email: email
      end
    end
  end
end