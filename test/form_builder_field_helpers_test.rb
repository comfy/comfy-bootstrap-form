require_relative "./test_helper"

class FormBuilderFieldHelpersTest < ActionView::TestCase

  setup do
    @builder = BootstrapForm::FormBuilder.new(:user, @user, self, {})
  end

  def test_text_field
    actual = @builder.text_field(:email)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_email">Email</label>
        <input class="form-control" type="text" name="user[email]" id="user_email" />
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  # TODO: add all field helper and test default output


  # TODO: move these to test specific internal methods. Below are for the `draw_label`

  def test_text_field_label_text
    actual = @builder.text_field(:email, bootstrap: {label: {text: "Custom Label"}})
    expected = <<-HTML
      <div class="form-group">
        <label for="user_email">Custom Label</label>
        <input class="form-control" type="text" name="user[email]" id="user_email" />
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_text_field_label_css_class
    actual = @builder.text_field(:email, bootstrap: {label: {class: "custom_class"}})
    expected = <<-HTML
      <div class="form-group">
        <label class="custom_class" for="user_email">Email</label>
        <input class="form-control" type="text" name="user[email]" id="user_email" />
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_text_field_label_hide
    actual = @builder.text_field(:email, bootstrap: {label: {hide: true}})
    expected = <<-HTML
      <div class="form-group">
        <label class="sr-only" for="user_email">Email</label>
        <input class="form-control" type="text" name="user[email]" id="user_email" />
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  # TODO: move to control rendering test file
  def test_text_field_control_css_class
    actual = @builder.text_field(:email, bootstrap: {control: {class: "custom_class"}})
    expected = <<-HTML
      <div class="form-group">
        <label for="user_email">Email</label>
        <input class="form-control custom_class" type="text" name="user[email]" id="user_email" />
      </div>
    HTML
    assert_xml_equal expected, actual
  end




  def test_text_field_help_text
    actual = @builder.text_field(:email, bootstrap: {help: "help text"})
    expected = <<-HTML
      <div class="form-group">
        <label for="user_email">Email</label>
        <input class="form-control" type="text" name="user[email]" id="user_email" />
        <small class="form-text text-muted">help text</small>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

end