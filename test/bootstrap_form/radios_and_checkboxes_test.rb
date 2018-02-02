require_relative "../test_helper"

class RadiosAndCheckboxessTest < ActionView::TestCase

  setup do
    @user     = User.new
    @builder  = BootstrapForm::FormBuilder.new(:user, @user, self, {})
  end

  def test_checkbox
    actual = @builder.check_box(:test)
    expected = <<-HTML
      <fieldset class="form-group">
        <div class="form-check">
          <input name="user[test]" type="hidden" value="0"/>
          <input class="form-check-input" id="user_test" name="user[test]" type="checkbox" value="1"/>
          <label class="form-check-label" for="user_test">Test</label>
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

end
