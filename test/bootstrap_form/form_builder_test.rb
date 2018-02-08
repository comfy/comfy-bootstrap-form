require_relative "../test_helper"

class FormBuilderTest < ActionView::TestCase

  def test_initialization
    builder = BootstrapForm::FormBuilder.new(nil, nil, self, {})
    assert builder.form_bootstrap.is_a?(BootstrapForm::BootstrapOptions)
    assert_equal "vertical", builder.form_bootstrap.layout
  end

  def test_initialization_with_options
    options = { bootstrap: { layout: "horizontal" } }
    builder = BootstrapForm::FormBuilder.new(nil, nil, self, options)
    assert_equal "horizontal", builder.form_bootstrap.layout
  end

end
