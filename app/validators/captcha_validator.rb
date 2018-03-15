# gönderilen captcha'nın doğruluğunu denetler
class CaptchaValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value == Session.data[:captcha]
    msg = 'Hatalı doğrulama kodu'
    record.errors[attribute] << (options[:message] || msg)
  end
end

