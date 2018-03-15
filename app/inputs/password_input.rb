class PasswordInput < SimpleForm::Inputs::PasswordInput
  def input(wrapper_options = nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    merged_input_options[:class] << 'is-invalid' if has_errors?

    @builder.password_field(attribute_name, merged_input_options)
  end
end

