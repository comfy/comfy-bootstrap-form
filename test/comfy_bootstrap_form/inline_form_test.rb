# frozen_string_literal: true

require_relative "../test_helper"

class InlineFormTest < ActionView::TestCase

  setup do
    @user     = User.new
    @builder  = ComfyBootstrapForm::FormBuilder.new(:user, @user, self, bootstrap: { layout: :inline })
  end

  def test_text_field
    actual = @builder.text_field(:email)
    expected = <<-HTML
      <div class="form-group mr-sm-2">
        <label class="mr-sm-2" for="user_email">Email</label>
        <input class="form-control" id="user_email" name="user[email]" type="text"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_check_box
    actual = @builder.check_box(:terms)
    expected = <<-HTML
      <fieldset class="form-group mr-sm-2">
        <div class="form-check">
          <input name="user[terms]" type="hidden" value="0"/>
          <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1"/>
          <label class="form-check-label" for="user_terms">Terms</label>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_submit
    actual = @builder.submit
    expected = <<-HTML
      <div class="form-group">
        <input class="btn" data-disable-with="Create User" name="commit" type="submit" value="Create User"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_form_group
    actual = @builder.form_group do
      "test"
    end
    expected = <<-HTML
      <div class="form-group mr-sm-2">test</div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_form_group_with_label
    actual = @builder.form_group(bootstrap: { label: { text: "Test" } }) do
      "test"
    end
    expected = <<-HTML
      <div class="form-group mr-sm-2">
        <label class="mr-sm-2">Test</label>
        test
      </div>
    HTML
    assert_xml_equal expected, actual
  end

end
