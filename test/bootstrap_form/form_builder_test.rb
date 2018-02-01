require_relative "../test_helper"

class FormBuilderTest < ActionView::TestCase

  def test_initialization
    builder = BootstrapForm::FormBuilder.new(nil, nil, self, {})

    assert_equal "default",       builder.bootstrap.layout
    assert_equal "col-sm-4",      builder.bootstrap.label_col_class
    assert_equal "col-sm-8",      builder.bootstrap.control_col_class
    assert_equal "text-sm-left",  builder.bootstrap.label_align_class
  end

  def test_initialization_with_options
    builder = BootstrapForm::FormBuilder.new(nil, nil, self, {
      skip_default_ids: true,
      bootstrap: {
        layout:             "horizontal",
        label_col_class:    "col-md-2",
        control_col_class:  "col-md-10",
        label_align_class:  "text-md-right"
      }
    })

    assert_equal "horizontal",    builder.bootstrap.layout
    assert_equal "col-md-2",      builder.bootstrap.label_col_class
    assert_equal "col-md-10",     builder.bootstrap.control_col_class
    assert_equal "text-md-right", builder.bootstrap.label_align_class
  end

end
