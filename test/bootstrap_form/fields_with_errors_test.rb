require_relative "../test_helper"

class FieldsWithErrorsTest < ActionView::TestCase

  setup do
    @user     = User.new
    @builder  = BootstrapForm::FormBuilder.new(:user, @user, self, {})

    @original_proc = ActionView::Base.field_error_proc
    ActionView::Base.field_error_proc = proc { |input, instance| input }
  end

  teardown do
    ActionView::Base.field_error_proc = @original_proc
  end

  def test_text_field_with_error
    @user.errors.add(:test, "invalid")
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

  def test_radio_buttons_with_error
    @user.errors.add(:test, "invalid")
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

end
