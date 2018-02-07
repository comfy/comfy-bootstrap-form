require_relative "../test_helper"

class BootstrapOptionsTest < ActionView::TestCase

  setup do
    @builder = BootstrapForm::FormBuilder.new(:user, nil, self, {
      bootstrap: {layout: "horizontal", label: {hide: true}}
    })
  end

  def test_defaults
    options = BootstrapForm::BootstrapOptions.new
    assert_equal "vertical",      options.layout
    assert_equal "col-sm-2",      options.label_col_class
    assert_equal "col-sm-10",     options.control_col_class
    assert_equal "text-sm-right", options.label_align_class
    assert_equal "mr-sm-2",       options.inline_margin_class
    assert_equal ({}),            options.label
    assert_nil                    options.append
    assert_nil                    options.prepend
    assert_nil                    options.help
    refute                        options.check_inline
  end

  def test_with_set_options
    options = BootstrapForm::BootstrapOptions.new(
      layout:               "horizontal",
      label_col_class:      "col-md-4",
      control_col_class:    "col-md-8",
      label_align_class:    "text-md-left",
      inline_margin_class:  "mr-md-4",
      label:                {text: "test"},
      append:               "a",
      prepend:              "z",
      help:                 "help text",
      check_inline:         "true"
    )
    assert_equal "horizontal",      options.layout
    assert_equal "col-md-4",        options.label_col_class
    assert_equal "col-md-8",        options.control_col_class
    assert_equal "text-md-left",    options.label_align_class
    assert_equal "mr-md-4",         options.inline_margin_class
    assert_equal ({text: "test"}),  options.label
    assert_equal "a",               options.append
    assert_equal "z",               options.prepend
    assert_equal "help text",       options.help
    assert                          options.check_inline
  end

  def test_with_set_invalid_options
    options = BootstrapForm::BootstrapOptions.new(invalid: "invalid")
    refute options.respond_to?(:invalid)
  end

  def test_horizontal
    options = BootstrapForm::BootstrapOptions.new
    refute options.horizontal?

    options = BootstrapForm::BootstrapOptions.new(layout: "horizontal")
    assert options.horizontal?
  end

  def test_inline
    options = BootstrapForm::BootstrapOptions.new
    refute options.inline?

    options = BootstrapForm::BootstrapOptions.new(layout: "inline")
    assert options.inline?
  end

  def test_offset_col_class
    options = BootstrapForm::BootstrapOptions.new
    assert_equal "offset-sm-2", options.offset_col_class

    options = BootstrapForm::BootstrapOptions.new(label_col_class: "col-md-4")
    assert_equal "offset-md-4", options.offset_col_class
  end

  def scoped
    options = BootstrapForm::BootstrapOptions.new
    refute options.horizontal?

    scoped_options = options.scoped(layout: "vertical")
    assert scoped_options.horizontal?
    refute options.horizontal?
  end

  def test_form_fields_global_options
    actual = @builder.text_field :email
    expected = <<-HTML
      <div class="form-group row">
        <label class="sr-only col-form-label col-sm-2 text-sm-right" for="user_email">Email</label>
        <div class="col-sm-10 offset-sm-2">
          <input class="form-control" id="user_email" name="user[email]" type="text"/>
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_form_fields_global_options_override
    actual = @builder.text_field :email, bootstrap: {layout: "vertical"}
    expected = <<-HTML
      <div class="form-group">
        <label class="sr-only" for="user_email">Email</label>
        <input class="form-control" id="user_email" name="user[email]" type="text"/>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

end
