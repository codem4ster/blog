class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
    msg = 'Geçersiz E-Posta'
    record.errors[attribute] << (options[:message] || msg)
  end
end

