# frozen_string_literal: true

require_relative "../test_helper"

class ViewHelpersTest < ActionView::TestCase

  include ComfyBootstrapForm::ViewHelper

  # Rails 6 doesn't use utf8 input anymore
  def utf8_input
    if Rails.version < "6.0.0"
      <<~HTML
        <input name="utf8" type="hidden" value="&#x2713;" />
      HTML
    end
  end

  def test_bootstrap_form_with
    skip if Rails.version < "5.1"

    actual = bootstrap_form_with(url: "/test") {}
    expected = <<-HTML
      <form action="/test" accept-charset="UTF-8" data-remote="true" method="post">
        #{utf8_input}
      </form>
    HTML
    assert_xml_equal expected, actual
  end

  def test_bootstrap_form_with_and_field
    skip if Rails.version < "5.1"

    actual = bootstrap_form_with(url: "/test") do |form|
      form.text_field :value
    end

    input =
      if Rails.version < "5.2"
        %(<input class="form-control" name="value" type="text"/>)
      else
        %(<input class="form-control" id="value" name="value" type="text"/>)
      end

    expected = <<-HTML
      <form accept-charset="UTF-8" action="/test" data-remote="true" method="post">
        #{utf8_input}
        <div class="form-group">
          <label for="value">Value</label>
          #{input}
        </div>
      </form>
    HTML
    assert_xml_equal expected, actual
  end

  def test_bootstrap_form_with_horizontal
    skip if Rails.version < "5.1"

    actual = bootstrap_form_with(url: "/test", bootstrap: { layout: "horizontal" }) do |form|
      form.text_field :value
    end

    input =
      if Rails.version < "5.2"
        %(<input class="form-control" name="value" type="text"/>)
      else
        %(<input class="form-control" id="value" name="value" type="text"/>)
      end

    expected = <<-HTML
      <form accept-charset="UTF-8" action="/test" data-remote="true" method="post">
        #{utf8_input}
        <div class="form-group row">
          <label class="col-form-label col-sm-2 text-sm-right" for="value">Value</label>
          <div class="col-sm-10">
            #{input}
          </div>
        </div>
      </form>
    HTML
    assert_xml_equal expected, actual
  end

  def test_bootstrap_form_with_inline
    skip if Rails.version < "5.1"

    actual = bootstrap_form_with(url: "/test", bootstrap: { layout: "inline" }) do |form|
      form.text_field :value
      form.submit
    end
    expected = <<-HTML
      <form accept-charset="UTF-8" action="/test" class="form-inline" data-remote="true" method="post">
        #{utf8_input}
        <div class="form-group">
          <input class="btn" data-disable-with="Save " name="commit" type="submit" value="Save "/>
        </div>
      </form>
    HTML
    assert_xml_equal expected, actual
  end

  def test_bootstrap_form_with_supress_field_errors
    skip if Rails.version < "5.1"

    user = User.new
    user.errors.add(:test, "invalid")
    actual = bootstrap_form_with(model: user, url: "/test") do |form|
      form.text_field :test
    end

    input =
      if Rails.version < "5.2"
        %(<input class="form-control is-invalid" name="user[test]" type="text"/>)
      else
        %(<input class="form-control is-invalid" id="user_test" name="user[test]" type="text"/>)
      end

    expected = <<-HTML
      <form accept-charset="UTF-8" action="/test" data-remote="true" method="post">
        #{utf8_input}
        <div class="form-group">
          <label for="user_test">Test</label>
          #{input}
          <div class="invalid-feedback">invalid</div>
        </div>
      </form>
    HTML
    assert_xml_equal expected, actual
  end

  def test_bootstrap_form_with_builder_override
    skip if Rails.version < "5.1"

    actual = bootstrap_form_with(url: "/test", builder: ActionView::Helpers::FormBuilder) do |form|
      form.text_field :value
    end

    input =
      if Rails.version < "5.2"
        %(<input name="value" type="text"/>)
      else
        %(<input id="value" name="value" type="text"/>)
      end

    expected = <<-HTML
      <form accept-charset="UTF-8" action="/test" data-remote="true" method="post">
        #{utf8_input}
        #{input}
      </form>
    HTML
    assert_xml_equal expected, actual
  end
end
