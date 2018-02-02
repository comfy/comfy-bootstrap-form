require_relative "../test_helper"

class FieldHelpersTest < ActionView::TestCase

  setup do
    @user     = User.new
    @builder  = BootstrapForm::FormBuilder.new(:user, @user, self, {})
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

  def test_plaintext
    actual = @builder.plaintext(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control-plaintext" readonly="readonly" type="text" name="user[test]" id="user_test"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_input_group
    actual = @builder.text_field(:test, bootstrap: {
      control: {prepend: "prepend", append: "append"}
    })
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <div class="input-group">
          <div class="input-group-prepend">
            <span class="input-group-text">prepend</span>
          </div>
          <input class="form-control" id="user_test" name="user[test]" type="text"/>
          <div class="input-group-append">
            <span class="input-group-text">append</span>
          </div>
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_text_field_with_error
    @user.errors.add(:test, "invalid")
    actual = supress_field_errors do
      @builder.text_field(:test)
    end
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control is-invalid" id="user_test" name="user[test]" type="text"/>
        <div class="invalid-feedback">invalid</div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_submit
    expected = <<-HTML
      <input class="btn" name="commit" type="submit" value="Create User" />
    HTML
    assert_xml_equal expected, @builder.submit
  end

  def test_primary
    expected = <<-HTML
      <input class="btn-primary btn" name="commit" type="submit" value="Create User" />
    HTML
    assert_xml_equal expected, @builder.primary
  end

  def test_submit_with_label
    expected = <<-HTML
      <input class="btn" name="commit" type="submit" value="Test" />
    HTML
    assert_xml_equal expected, @builder.submit("Test")
  end

  def test_submit_with_css_class
    expected = <<-HTML
      <input class="custom btn" name="commit" type="submit" value="Create User" />
    HTML
    assert_xml_equal expected, @builder.submit(class: "custom")
  end

  def test_submit_with_block
    actual = @builder.submit do
      %{<a href="/" class="btn btn-link">Cancel</a>}.html_safe
    end
    expected = <<-HTML
      <input class="btn" name="commit" type="submit" value="Create User"/>
      <a href="/" class="btn btn-link">Cancel</a>
    HTML
    assert_xml_equal expected, actual
  end

  def test_radio_buttons
    actual = @builder.radio_buttons(:test, ["a", "b"])
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label">Test</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_test_a" name="user[test]" type="radio" value="a"/>
          <label class="form-check-label" for="user_test_a">A</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_test_b" name="user[test]" type="radio" value="b"/>
          <label class="form-check-label" for="user_test_b">B</label>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_radio_buttons_with_labels
    actual = @builder.radio_buttons(:test, [["a", "Label A"], ["b", "Label B"]])
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label">Test</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_test_a" name="user[test]" type="radio" value="a"/>
          <label class="form-check-label" for="user_test_a">Label A</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_test_b" name="user[test]" type="radio" value="b"/>
          <label class="form-check-label" for="user_test_b">Label B</label>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_radio_buttons_inline
    actual = @builder.radio_buttons(:test, ["a", "b"], bootstrap: {inline: true})
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label">Test</legend>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_test_a" name="user[test]" type="radio" value="a"/>
          <label class="form-check-label" for="user_test_a">A</label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_test_b" name="user[test]" type="radio" value="b"/>
          <label class="form-check-label" for="user_test_b">B</label>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_radio_buttons_custom_label
    actual = @builder.radio_buttons(:test, ["a", "b"], bootstrap: {label: {text: "Custom"}})
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label">Custom</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_test_a" name="user[test]" type="radio" value="a"/>
          <label class="form-check-label" for="user_test_a">A</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_test_b" name="user[test]" type="radio" value="b"/>
          <label class="form-check-label" for="user_test_b">B</label>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_radio_buttons_no_label
    actual = @builder.radio_buttons(:test, ["a", "b"], bootstrap: {label: {hide: true}})
    expected = <<-HTML
      <fieldset class="form-group">
        <div class="form-check">
          <input class="form-check-input" id="user_test_a" name="user[test]" type="radio" value="a"/>
          <label class="form-check-label" for="user_test_a">A</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_test_b" name="user[test]" type="radio" value="b"/>
          <label class="form-check-label" for="user_test_b">B</label>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_check_boxes
    actual = @builder.check_boxes(:test, ["a", "b"])
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label">Test</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_test_a" name="user[test][]" type="checkbox" value="a"/>
          <label class="form-check-label" for="user_test_a">A</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_test_b" name="user[test][]" type="checkbox" value="b"/>
          <label class="form-check-label" for="user_test_b">B</label>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

end
