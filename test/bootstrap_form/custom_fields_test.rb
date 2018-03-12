# frozen_string_literal: true

require_relative "../test_helper"

class CustomFieldsTest < ActionView::TestCase

  setup do
    @user     = User.new
    @builder  = BootstrapForm::FormBuilder.new(:user, @user, self, {})
  end

  def test_file_field
    actual = @builder.file_field(:test, bootstrap: { custom_control: true })
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <div class="custom-file">
          <input class="custom-file-input" id="user_test" name="user[test]" type="file"/>
          <label class="custom-file-label" for="user_test">Test</label>
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_file_field_with_placeholder
    actual = @builder.file_field(:test, placeholder: "Choose File", bootstrap: { custom_control: true })
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <div class="custom-file">
          <input class="custom-file-input" id="user_test" name="user[test]" type="file"/>
          <label class="custom-file-label" for="user_test">Choose File</label>
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_file_field_with_custom_id
    actual = @builder.file_field(:test, id: "custom", bootstrap: { custom_control: true })
    expected = <<-HTML
      <div class="form-group">
        <label for="custom">Test</label>
        <div class="custom-file">
          <input class="custom-file-input" id="custom" name="user[test]" type="file"/>
          <label class="custom-file-label" for="custom">Test</label>
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_check_box
    actual = @builder.check_box(:test, bootstrap: { custom_control: true })
    expected = <<-HTML
      <fieldset class="form-group">
        <div class="custom-control custom-checkbox">
          <input name="user[test]" type="hidden" value="0"/>
          <input class="custom-control-input" id="user_test" name="user[test]" type="checkbox" value="1"/>
          <label class="custom-control-label" for="user_test">Test</label>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_collection_check_boxes
    actual = @builder.collection_check_boxes(:test, %w[a b], :to_s, :to_s, bootstrap: { custom_control: true })
    expected = <<-HTML
    <input id="user_test" multiple="multiple" name="user[test][]" type="hidden" value=""/>
    <fieldset class="form-group">
      <legend class="col-form-label pt-0">Test</legend>
      <div class="custom-control custom-checkbox">
        <input class="custom-control-input" id="user_test_a" name="user[test][]" type="checkbox" value="a"/>
        <label class="custom-control-label" for="user_test_a">a</label>
      </div>
      <div class="custom-control custom-checkbox">
        <input class="custom-control-input" id="user_test_b" name="user[test][]" type="checkbox" value="b"/>
        <label class="custom-control-label" for="user_test_b">b</label>
      </div>
    </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_collection_radio_buttons
    actual = @builder.collection_radio_buttons(:test, %w[a b], :to_s, :to_s, bootstrap: { custom_control: true })
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label pt-0">Test</legend>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" id="user_test_a" name="user[test]" type="radio" value="a"/>
          <label class="custom-control-label" for="user_test_a">a</label>
        </div>
        <div class="custom-control custom-radio">
          <input class="custom-control-input" id="user_test_b" name="user[test]" type="radio" value="b"/>
          <label class="custom-control-label" for="user_test_b">b</label>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_collection_radio_buttons_inline
    options = { bootstrap: { custom_control: true, check_inline: true } }
    actual = @builder.collection_radio_buttons(:test, %w[a b], :to_s, :to_s, options)
    expected = <<-HTML
      <fieldset class="form-group">
        <legend class="col-form-label pt-0">Test</legend>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" id="user_test_a" name="user[test]" type="radio" value="a"/>
          <label class="custom-control-label" for="user_test_a">a</label>
        </div>
        <div class="custom-control custom-radio custom-control-inline">
          <input class="custom-control-input" id="user_test_b" name="user[test]" type="radio" value="b"/>
          <label class="custom-control-label" for="user_test_b">b</label>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

end
