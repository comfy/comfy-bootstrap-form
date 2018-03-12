# frozen_string_literal: true

require_relative "../test_helper"

class HorizontalFormTest < ActionView::TestCase

  setup do
    @user     = User.new
    @builder  = BootstrapForm::FormBuilder.new(:user, @user, self, bootstrap: { layout: :horizontal })
  end

  def test_text_field
    actual = @builder.text_field(:email)
    expected = <<-HTML
      <div class="form-group row">
        <label class="col-form-label col-sm-2 text-sm-right" for="user_email">Email</label>
        <div class="col-sm-10">
          <input class="form-control" type="text" name="user[email]" id="user_email" />
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_text_field_with_no_label
    actual = @builder.text_field(:email, bootstrap: { label: { hide: true } })
    expected = <<-HTML
      <div class="form-group row">
        <label class="sr-only col-form-label col-sm-2 text-sm-right" for="user_email">Email</label>
        <div class="col-sm-10 offset-sm-2">
          <input class="form-control" type="text" name="user[email]" id="user_email" />
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_check_box
    actual = @builder.check_box(:terms)
    expected = <<-HTML
      <fieldset class="form-group row">
        <div class="col-sm-10 offset-sm-2">
          <div class="form-check">
            <input name="user[terms]" type="hidden" value="0"/>
            <input class="form-check-input" id="user_terms" name="user[terms]" type="checkbox" value="1"/>
            <label class="form-check-label" for="user_terms">Terms</label>
          </div>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_collection_radio_buttons
    actual = @builder.collection_radio_buttons(:test, %w[a b], :to_s, :titleize)
    expected = <<-HTML
      <fieldset class="form-group">
        <div class="row">
          <legend class="col-form-label pt-0 col-sm-2 text-sm-right">Test</legend>
          <div class="col-sm-10">
            <div class="form-check">
              <input class="form-check-input" id="user_test_a" name="user[test]" type="radio" value="a"/>
              <label class="form-check-label" for="user_test_a">A</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" id="user_test_b" name="user[test]" type="radio" value="b"/>
              <label class="form-check-label" for="user_test_b">B</label>
            </div>
          </div>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_collection_check_boxes_with_no_label
    actual = @builder.collection_check_boxes(:test, %w[a b], :to_s, :titleize, bootstrap: { label: { hide: true } })
    expected = <<-HTML
      <input id="user_test" multiple="multiple" name="user[test][]" type="hidden" value=""/>
      <fieldset class="form-group">
        <div class="row">
          <div class="col-sm-10 offset-sm-2">
            <div class="form-check">
              <input class="form-check-input" id="user_test_a" name="user[test][]" type="checkbox" value="a"/>
              <label class="form-check-label" for="user_test_a">A</label>
            </div>
            <div class="form-check">
              <input class="form-check-input" id="user_test_b" name="user[test][]" type="checkbox" value="b"/>
              <label class="form-check-label" for="user_test_b">B</label>
            </div>
          </div>
        </div>
      </fieldset>
    HTML
    assert_xml_equal expected, actual
  end

  def test_submit
    actual = @builder.submit
    expected = <<-HTML
      <div class="form-group row">
        <div class="col-sm-10 offset-sm-2">
          <input class="btn" data-disable-with="Create User" name="commit" type="submit" value="Create User"/>
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_input_group_with_options
    options = { bootstrap: {
      prepend:  "prepend",
      append:   "append",
      help:     "help me"
    } }
    actual = @builder.text_field(:test, options)
    expected = <<-HTML
      <div class="form-group row">
        <label class="col-form-label col-sm-2 text-sm-right" for="user_test">Test</label>
        <div class="col-sm-10">
          <div class="input-group">
            <div class="input-group-prepend">
              <span class="input-group-text">prepend</span>
            </div>
            <input class="form-control" id="user_test" name="user[test]" type="text"/>
            <div class="input-group-append">
              <span class="input-group-text">append</span>
            </div>
          </div>
          <small class="form-text text-muted">help me</small>
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_form_group
    actual = @builder.form_group do
      "test"
    end
    expected = <<-HTML
      <div class="form-group row">
        <div class="col-sm-10 offset-sm-2">test</div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_form_group_with_label
    actual = @builder.form_group(bootstrap: { label: { text: "Test" } }) do
      "test"
    end
    expected = <<-HTML
      <div class="form-group row">
        <label class="col-form-label col-sm-2 text-sm-right">Test</label>
        <div class="col-sm-10">test</div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

end
