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

  def test_select
    actual = @builder.select(:test, %w[a b])
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <select class="form-control" id="user_test" name="user[test]">
          <option value="a">a</option>
          <option value="b">b</option>
        </select>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_select_control_css_class
    actual = @builder.select(:test, %w[a b], {}, bootstrap: {control: {class: "custom"}})
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <select class="form-control custom" id="user_test" name="user[test]">
          <option value="a">a</option>
          <option value="b">b</option>
        </select>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_checkbox
    actual = @builder.check_box(:test)
    expected = <<-HTML
      <div class="form-check">
        <input name="user[test]" type="hidden" value="0"/>
        <input class="form-check-input" id="user_test" name="user[test]" type="checkbox" value="1"/>
        <label class="form-check-label" for="user_test">Test</label>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_color_field
    actual = @builder.color_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="color" name="user[test]" id="user_test" value="#000000"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_date_field
    actual = @builder.date_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="date" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_datetime_field
    actual = @builder.datetime_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="datetime-local" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_email_field
    actual = @builder.email_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="email" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_file_field
    actual = @builder.file_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="file" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_month_field
    actual = @builder.month_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="month" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_number_field
    actual = @builder.number_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="number" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_password_field
    actual = @builder.password_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="password" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_phone_field
    actual = @builder.phone_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="tel" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_range_field
    actual = @builder.range_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="range" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_search_field
    actual = @builder.search_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="search" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_text_area
    actual = @builder.text_area(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <textarea class="form-control" name="user[test]" id="user_test"/></textarea>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_time_field
    actual = @builder.time_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="time" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_url_field
    actual = @builder.url_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="url" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_week_field
    actual = @builder.week_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control" type="week" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

end
