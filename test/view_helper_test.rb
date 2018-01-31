require_relative "./test_helper"

class ViewHelperTest < ActionView::TestCase

  include BootstrapForm::ViewHelper

  def test_bootstrap_form_with
    expected = <<-HTML
      <form action="/test" accept-charset="UTF-8" data-remote="true" method="post">
        <input name="utf8" type="hidden" value="&#x2713;" />
      </form>
    HTML
    actual = bootstrap_form_with(url: "/test"){ }
    assert_equivalent_xml expected, actual
  end

  def test_bootstrap_form_with_and_field
    expected = <<-HTML
      <form accept-charset="UTF-8" action="/test" data-remote="true" method="post">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <label for="value">Value</label>
          <input class="form-control" name="value" type="text"/>
        </div>
      </form>
    HTML
    actual = bootstrap_form_with(url: "/test") do |form|
      form.text_field :value
    end
    assert_equivalent_xml expected, actual
  end

  def test_bootstrap_form_with_inline
    expected = <<-HTML
      <form accept-charset="UTF-8" action="/test" class="custom form-inline" data-remote="true" method="post">
        <input name="utf8" type="hidden" value="&#x2713;"/>
        <div class="form-group">
          <label for="value">Value</label>
          <input class="form-control" name="value" type="text"/>
        </div>
      </form>
    HTML
    actual = bootstrap_form_with(url: "/test", class: "custom", bootstrap: {layout: :inline}) do |form|
      form.text_field :value
    end
    assert_equivalent_xml expected, actual
  end

  def test_bootstrap_form_with_horizontal
    expected = <<-HTML
      TODO
    HTML
    actual = bootstrap_form_with(url: "/test", class: "custom", bootstrap: {layout: :horizontal}) do |form|
      form.text_field :value
    end
    assert_equivalent_xml expected, actual
  end

  def test_bootstrap_fields
    flunk "todo"
  end

  def test_bootstrap_form_with_supress_field_errors
    flunk "todo"
  end

end
