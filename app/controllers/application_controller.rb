class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :make_session_global

  def captcha
    captcha = Operations::GenerateCaptcha.run!(
      generator: CaptchaImageGenerator.new(100, 32)
    )
    session['captcha'] = captcha[:hash]
    add_no_cache_to_response
    send_data captcha[:image],
              type: 'image.jpeg', disposition: 'inline'
  end

  private

  def add_no_cache_to_response
    response.headers['Pragma-Directive'] = 'no-cache'
    response.headers['Cache-Directive'] = 'no-cache'
    response.headers['Cache-Control'] = 'no-cache'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = '0'
  end

  def make_session_global
    # Session.init(session)
  end

  def current_user
    User.current
  end
end
