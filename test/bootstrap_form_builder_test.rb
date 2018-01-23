require_relative "./test_helper"

class BootstrapFormBuilderTest < ActionView::TestCase

  def test_initialization
    builder = BootstrapForm::FormBuilder.new(nil, nil, self, {})

    assert_equal "default",       builder.bootstrap_options.layout
    assert_equal "col-sm-4",      builder.bootstrap_options.label_col_class
    assert_equal "col-sm-8",      builder.bootstrap_options.control_col_class
    assert_equal "text-sm-left",  builder.bootstrap_options.label_align_class
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

    assert_equal "horizontal",    builder.bootstrap_options.layout
    assert_equal "col-md-2",      builder.bootstrap_options.label_col_class
    assert_equal "col-md-10",     builder.bootstrap_options.control_col_class
    assert_equal "text-md-right", builder.bootstrap_options.label_align_class
  end

end