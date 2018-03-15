class CaptchaInput < SimpleForm::Inputs::Base
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options,
                                                 wrapper_options)
    @builder.text_field(attribute_name, merged_input_options).html_safe
  end

  def captcha_img(_)
    '<img id="captcha" src="/captcha" />'
  end

  def captcha_refresh(_)
    '<span class="ico-arrows-ccw"></span>'
  end

end

