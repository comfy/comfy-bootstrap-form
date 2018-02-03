require_relative "../test_helper"

class ViewHelpersTest < ActionView::TestCase

  include BootstrapForm::ViewHelper

  def test_bootstrap_form_with
    actual = bootstrap_form_with(url: "/test"){ }
    expected = <<-HTML
      <form action="/test" accept-charset="UTF-8" data-remote="true" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" />
      </form>
    HTML
    assert_xml_equal expected, actual
  end

  def test_bootstrap_form_with_and_field
    actual = bootstrap_form_with(url: "/test") do |form|
      form.text_field :value
    end
    expected = <<-HTML
      <form accept-charset="UTF-8" action="/test" data-remote="true" method="post">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <label for="value">Value</label>
          <input class="form-control" id="value" name="value" type="text"/>
        </div>
      </form>
    HTML
    assert_xml_equal expected, actual
  end

  def test_bootstrap_form_as_horizontal
    actual = bootstrap_form_with(url: "/test", bootstrap: {layout: :horizontal}) do |form|
      form.text_field :value
    end
    expected = <<-HTML
      <form accept-charset="UTF-8" action="/test" data-remote="true" method="post">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group row">
          <label class="col-form-label col-sm-2 text-sm-right" for="value">Value</label>
          <div class="col-sm-10">
            <input class="form-control" id="value" name="value" type="text"/>
          </div>
        </div>
      </form>
    HTML
    assert_xml_equal expected, actual
  end

  def test_bootstrap_form_with_inline
    skip "todo"
  end

  def test_bootstrap_form_with_supress_field_errors
    user = User.new
    user.errors.add(:test, "invalid")
    actual = bootstrap_form_with(model: user, url: "/test") do |form|
      form.text_field :test
    end
    expected = <<-HTML
      <form accept-charset="UTF-8" action="/test" data-remote="true" method="post">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <label for="user_test">Test</label>
          <input class="form-control is-invalid" id="user_test" name="user[test]" type="text"/>
          <div class="invalid-feedback">invalid</div>
        </div>
      </form>
    HTML
    assert_xml_equal expected, actual
  end

end
