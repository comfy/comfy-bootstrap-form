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

  def test_checkbox_with_label
    actual = @builder.check_box(:test, bootstrap: { label: { text: "Custom" } })
    expected = <<-HTML
      <fieldset class="form-group">
        <div class="form-check">
          <input name="user[test]" type="hidden" value="0"/>
          <input class="form-check-input" id="user_test" name="user[test]" type="checkbox" value="1"/>
          <label class="form-check-label" for="user_test">Custom</label>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_checkbox_with_help
    actual = @builder.check_box(:test, bootstrap: { help: "help me" })
    expected = <<-HTML
      <fieldset class="form-group">
        <div class="form-check">
          <input name="user[test]" type="hidden" value="0"/>
          <input class="form-check-input" id="user_test" name="user[test]" type="checkbox" value="1"/>
          <label class="form-check-label" for="user_test">Test</label>
          <small class="form-text text-muted">help me</small>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_collection_check_boxes
    actual = @builder.collection_check_boxes(:test, %w[a b], :to_s, :titleize)
    expected = <<-HTML
      <input id="user_test" multiple="multiple" name="user[test][]" type="hidden" value=""/>
      <fieldset class="form-group">
        <legend class="col-form-label pt-0">Test</legend>
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

  def test_collection_checkboxes_without_hidden_field
    actual = @builder.collection_check_boxes(:test, %w[a b], :to_s, :titleize, include_hidden: false)
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label pt-0">Test</legend>
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
    actual = @builder.collection_radio_buttons(:test, %w[a b], :to_s, :titleize)
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label pt-0">Test</legend>
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

  def test_radio_buttons_inline
    options = { bootstrap: { check_inline: true } }
    actual = @builder.collection_radio_buttons(:test, %w[a b], :to_s, :titleize, options)
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label pt-0">Test</legend>
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
    options = { bootstrap: { label: { text: "Custom" } } }
    actual = @builder.collection_radio_buttons(:test, %w[a b], :to_s, :titleize, options)
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label pt-0">Custom</legend>
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
    options = { bootstrap: { label: { hide: true } } }
    actual = @builder.collection_radio_buttons(:test, %w[a b], :to_s, :titleize, options)
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

  def test_radio_buttons_with_help
    options = { bootstrap: { help: "help me" } }
    actual = @builder.collection_radio_buttons(:test, %w[a b], :to_s, :titleize, options)
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label pt-0">Test</legend>
        <div class="form-check">
          <input class="form-check-input" id="user_test_a" name="user[test]" type="radio" value="a"/>
          <label class="form-check-label" for="user_test_a">A</label>
        </div>
        <div class="form-check">
          <input class="form-check-input" id="user_test_b" name="user[test]" type="radio" value="b"/>
          <label class="form-check-label" for="user_test_b">B</label>
          <small class="form-text text-muted">help me</small>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_radio_buttons_with_inline_help
    options = { bootstrap: {
      check_inline: true,
      help:         "help me"
    } }
    actual = @builder.collection_radio_buttons(:test, %w[a b], :to_s, :titleize, options)
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label pt-0">Test</legend>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_test_a" name="user[test]" type="radio" value="a"/>
          <label class="form-check-label" for="user_test_a">A</label>
        </div>
        <div class="form-check form-check-inline">
          <input class="form-check-input" id="user_test_b" name="user[test]" type="radio" value="b"/>
          <label class="form-check-label" for="user_test_b">B</label>
        </div>
        <small class="form-text text-muted">help me</small>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

end
