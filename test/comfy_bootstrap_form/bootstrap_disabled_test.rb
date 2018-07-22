# frozen_string_literal: true

require_relative "../test_helper"

class DisabledBootstrapTest < ActionView::TestCase

  setup do
    @user     = User.new
    @builder  = ComfyBootstrapForm::FormBuilder.new(:user, @user, self, {})
  end

  def test_text_field
    actual = @builder.text_field(:email, bootstrap: { disabled: true })
    expected = <<-HTML
      <input id="user_email" name="user[email]" type="text"/>
    HTML
    assert_xml_equal expected, actual
  end

  def test_select
    actual = @builder.select(:test, %w[a b], bootstrap: { disabled: true })
    expected = <<-HTML
      <select id="user_test" name="user[test]">
        <option value="a">a</option>
        <option value="b">b</option>
      </select>
    HTML
    assert_xml_equal expected, actual
  end

  def test_file_field
    actual = @builder.file_field(:test, bootstrap: { disabled: true })
    expected = <<-HTML
      <input id="user_test" name="user[test]" type="file"/>
    HTML
    assert_xml_equal expected, actual
  end

  def test_check_box
    actual = @builder.check_box(:test, bootstrap: { disabled: true })
    expected = <<-HTML
      <input name="user[test]" type="hidden" value="0"/>
      <input id="user_test" name="user[test]" type="checkbox" value="1"/>
    HTML
    assert_xml_equal expected, actual
  end

  def test_collection_check_boxes
    actual = @builder.collection_check_boxes(:test, %w[a b], :to_s, :titleize, bootstrap: { disabled: true })
    expected = <<-HTML
      <input name="user[test][]" type="hidden" value=""/>
      <input id="user_test_a" name="user[test][]" type="checkbox" value="a"/>
      <label for="user_test_a">A</label>
      <input id="user_test_b" name="user[test][]" type="checkbox" value="b"/>
      <label for="user_test_b">B</label>
    HTML
    assert_xml_equal expected, actual
  end

  def test_radio_buttons
    actual = @builder.collection_radio_buttons(:test, %w[a b], :to_s, :titleize, bootstrap: { disabled: true })
    expected = <<-HTML
      <input name="user[test]" type="hidden" value=""/>
      <input id="user_test_a" name="user[test]" type="radio" value="a"/>
      <label for="user_test_a">A</label>
      <input id="user_test_b" name="user[test]" type="radio" value="b"/>
      <label for="user_test_b">B</label>
    HTML
    assert_xml_equal expected, actual
  end

  def test_submit
    expected = <<-HTML
      <input data-disable-with="Create User" name="commit" type="submit" value="Create User"/>
    HTML
    assert_xml_equal expected, @builder.submit(bootstrap: { disabled: true })
  end

end