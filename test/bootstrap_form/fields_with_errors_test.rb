require_relative "../test_helper"

class FieldsWithErrorsTest < ActionView::TestCase

  setup do
    @user = User.new
    @user.errors.add(:test, "invalid")

    @builder  = BootstrapForm::FormBuilder.new(:user, @user, self, {})

    @original_proc = ActionView::Base.field_error_proc
    ActionView::Base.field_error_proc = proc { |input, instance| input }
  end

  teardown do
    ActionView::Base.field_error_proc = @original_proc
  end

  def test_text_field_with_error
    actual = @builder.text_field(:test)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <input class="form-control is-invalid" id="user_test" name="user[test]" type="text"/>
        <div class="invalid-feedback">invalid</div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_check_box_with_error
    actual = @builder.check_box(:test)
    expected = <<-HTML
      <fieldset class="form-group">
        <div class="form-check">
          <input name="user[test]" type="hidden" value="0"/>
          <input class="form-check-input is-invalid" id="user_test" name="user[test]" type="checkbox" value="1"/>
          <label class="form-check-label" for="user_test">Test</label>
          <div class="invalid-feedback">invalid</div>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_radio_buttons_with_error
    actual = @builder.radio_buttons(:test, ["a", "b"])
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label">Test</legend>
        <div class="form-check">
          <input class="form-check-input is-invalid" id="user_test_a" name="user[test]" type="radio" value="a"/>
          <label class="form-check-label" for="user_test_a">A</label>
        </div>
        <div class="form-check">
          <input class="form-check-input is-invalid" id="user_test_b" name="user[test]" type="radio" value="b"/>
          <label class="form-check-label" for="user_test_b">B</label>
          <div class="invalid-feedback">invalid</div>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_text_field_with_input_group_error
    actual = @builder.text_field(:test, bootstrap: {control: {prepend: "A", append: "Z"}})
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <div class="input-group">
          <div class="input-group-prepend">
            <span class="input-group-text">A</span>
          </div>
          <input class="form-control is-invalid" id="user_test" name="user[test]" type="text"/>
          <div class="input-group-append">
            <span class="input-group-text">Z</span>
          </div>
          <div class="invalid-feedback">invalid</div>
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

end
