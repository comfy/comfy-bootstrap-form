module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder

    FIELD_HELPERS = %w[
      color_field     date_field  datetime_field  datetime_local_field
      email_field     file_field  month_field     number_field
      password_field  phone_field range_field     search_field
      text_area       text_field  time_field      url_field
      week_field
    ].freeze

    # Container for bootstrap specific form builder options. It controls options
    # that define form layout and grid sizing.
    class BootstrapOptions

      attr_accessor :layout,
                    :label_col_class,
                    :control_col_class,
                    :label_align_class

      def initialize(options = {})
        @layout             = options[:layout]            || "default"
        @label_col_class    = options[:label_col_class]   || "col-sm-4"
        @control_col_class  = options[:control_col_class] || "col-sm-8"
        @label_align_class  = options[:label_align_class] || "text-sm-left"
      end

    end

    delegate :content_tag, :capture, :concat, to: :@template

    attr_accessor :bootstrap

    def initialize(object_name, object, template, options)
      @bootstrap = BootstrapOptions.new(options.delete(:bootstrap) || {})
      super(object_name, object, template, options)
    end

    # Overriding default methods to forward everything to field_helper
    FIELD_HELPERS.each do |field_helper|
      class_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
        def #{field_helper}(method, options = {})
          field_helper(method, options) do
            super(method, options)
          end
        end
      RUBY_EVAL
    end

    # Wrapper for select helper. Boostrap options are sent via html_options hash:
    #
    #   select :choices, ["a", "b"], {}, bootstrap: {label: {text: "Custom"}}
    #
    def select(method, choices = nil, options = {}, html_options = {}, &block)
      bootstrap_options = (html_options.delete(:bootstrap) || {})
      draw_form_group(bootstrap_options, method, html_options) do
        super(method, choices, options, html_options, &block)
      end
    end

    # Wrapper around checkbox. Example usage:
    #
    #   checkbox :agree, bootstrap: {label: {text: "Do you agree?"}}
    #
    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      bootstrap_options         = (options.delete(:bootstrap)   || {})
      bootstrap_label_options   = (bootstrap_options[:label]    || {})

      content_tag(:fieldset, class: "form-group") do
        content_tag(:div, class: "form-check") do
          add_css_class!(options, "form-check-input")
          concat super(method, options, checked_value, unchecked_value)

          add_css_class!(bootstrap_label_options, "form-check-label")
          concat draw_label(bootstrap_label_options, method)
        end
      end
    end

    # Helper to generate multiple radio buttons. Example usage:
    #
    #   radio_buttons :choices, ["a", "b"] %>
    #   radio_buttons :choices, [["a", "Label A"], ["b", "Label B"]]
    #
    # Takes bootstrap options:
    #   :inline - set to true to render inputs inline
    #   label: {text: "Custom"} - to specify a label
    #   label: {hide: true}     - to not render label at all
    #
    def radio_buttons(method, choices, options = {})
      bootstrap_options = (options.delete(:bootstrap) || {})

      draw_choices(bootstrap_options, method, choices, options) do |m, v, opts|
        radio_button(m, v, opts)
      end
    end

    # Helper to generate multiple checkboxes. Same options as for radio buttons.
    # Example usage:
    #
    #   check_boxes :choices, ["a", "b"] %>
    #   check_boxes :choices, [["a", "Label A"], ["b", "Label B"]]
    #
    def check_boxes(method, choices, options = {})
      bootstrap_options = (options.delete(:bootstrap) || {})

      draw_choices(bootstrap_options, method, choices, options) do |m, v, opts|
        opts[:multiple]       = true
        opts[:include_hidden] = false
        ActionView::Helpers::FormBuilder.instance_method(:check_box).bind(self)
          .call(m, opts, v)
      end
    end

    # Bootstrap wrapper for readonly text field that is shown as plain text.
    #
    #   plaintext(:value)
    #
    def plaintext(method, options = {})
      bootstrap_options = (options.delete(:bootstrap) || {})
      draw_form_group(bootstrap_options, method, options) do
        remove_css_class!(options, "form-control")
        add_css_class!(options, "form-control-plaintext")
        options[:readonly] = true
        ActionView::Helpers::FormBuilder.instance_method(:text_field).bind(self).call(method, options)
      end
    end

    # Add bootstrap formatted submit button. If you need to change its type or
    # add another css class, you need to override all css classes like so:
    #
    #   submit(class: "btn btn-info custom-class")
    #
    # You may add additional content that directly follows the button. Here's
    # an example of a cancel link:
    #
    #   submit do
    #     link_to("Cancel", "/", class: "btn btn-link")
    #   end
    #
    def submit(value = nil, options = {}, &block)
      value, options = nil, value if value.is_a?(Hash)
      add_css_class!(options, "btn")
      out = super(value, options)
      out += capture(&block) if block_given?
      out
    end

    # Same as submit button, only with btn-primary class added
    def primary(value = nil, options = {}, &block)
      add_css_class!(options, "btn-primary")
      submit(value, options, &block)
    end

  private

    # Wrapper for all field helpers. Example usage:
    #
    #   bootstrap_form_with model: @user do |form|
    #     form.text_field :name
    #   end
    #
    # Output of the `text_field` will be wrapped in Bootstrap markup
    #
    def field_helper(method, options, &block)
      bootstrap_options = (options.delete(:bootstrap) || {})
      draw_form_group(bootstrap_options, method, options) do
        yield
      end
    end

    # form group wrapper for input fields
    def draw_form_group(bootstrap_options, method, options, &block)
      bootstrap_label_options   = (bootstrap_options[:label]    || {})
      bootstrap_control_options = (bootstrap_options[:control]  || {})

      label = draw_label(bootstrap_label_options, method)

      if (errors = object && object.errors[method]).present?
        errors_text = content_tag(:div, class: "invalid-feedback") do
          errors.join(", ")
        end
      end

      control = draw_control(bootstrap_control_options, method, options) do
        add_css_class!(options, "is-invalid") if errors.present?
        yield
      end

      help_text = draw_help(bootstrap_options[:help])

      content_tag(:div, class: "form-group") do
        concat label
        concat control
        concat errors_text if errors_text.present?
        concat help_text
      end
    end

    # Renders label for a given field. Takes following bootstrap options:
    #
    # :text   - replace default label text
    # :class  - css class on the label
    # :hide   - if `true` will render for screen readers only
    #
    # This is how those options can be passed in:
    #
    #   text_field(:value, bootstrap: {label: {text: "Custom", class: "custom"}})
    #
    def draw_label(bootstrap_label_options, method)
      text    = nil
      options = {}

      if (custom_text = bootstrap_label_options[:text]).present?
        text = custom_text
      end

      add_css_class!(options, bootstrap_label_options[:class])
      add_css_class!(options, "sr-only") if bootstrap_label_options[:hide]

      label(method, text, options)
    end

    # Renders control for a given field. Takes following bootstrap options:
    #
    # :class - custom css class
    #
    # Example how those options are passed in:
    #
    #   text_field(:value, bootstrap: {control: {class: "custom"}})
    #
    def draw_control(bootstrap_control_options, method, options, &block)
      add_css_class!(options, "form-control")

      # TODO: is this even needed? class option comes directly from field
      add_css_class!(options, bootstrap_control_options[:class])

      draw_input_group(bootstrap_control_options) do
        yield
      end
    end

    # Wraps input field in input group container that allows prepending and
    # appending text or html. Example:
    #
    #   text_field(:value, bootstrap: {control: {prepend: "$.$$"}})
    #
    def draw_input_group(bootstrap_control_options, &block)
      prepend = bootstrap_control_options[:prepend]
      append  = bootstrap_control_options[:append]

      return yield if prepend.blank? && append.blank?

      if prepend.present?
        prepend_html = content_tag(:div, class: "input-group-prepend") do
          content_tag(:span, class: "input-group-text") do
            prepend
          end
        end
      end

      if append.present?
        append_html = content_tag(:div, class: "input-group-append") do
          content_tag(:span, class: "input-group-text") do
            append
          end
        end
      end

      content_tag(:div, class: "input-group") do
        concat prepend_html if prepend_html.present?
        concat capture(&block)
        concat append_html if append_html.present?
      end
    end

    # Drawing boostrap form field help text. Example usage:
    #
    #   text_field(:value, bootstrap: {help: "help text"})
    #
    def draw_help(text)
      return if text.blank?
      content_tag(:small, text, class: "form-text text-muted")
    end

    # Rendering of choices for checkboxes and radio buttons
    def draw_choices(bootstrap_options, method, choices, options = {}, &input)
      add_css_class!(options, "form-check-input")

      draw_form_group_fieldset(bootstrap_options, method, options) do

        form_check_css_class = "form-check"
        form_check_css_class << " form-check-inline" if bootstrap_options[:inline]

        choices.map do |input_value, label_text|
          content_tag(:div, class: form_check_css_class) do
            concat input.call(method, input_value, options)
            concat label(method, label_text, value: input_value, class: "form-check-label")
          end
        end.join.html_safe
      end
    end

    # Wrapper for collections of radio buttons and checkboxes
    def draw_form_group_fieldset(bootstrap_options, method, options, &block)
      bootstrap_label_options = bootstrap_options[:label] || {}

      unless bootstrap_label_options[:hide]
        label_text = if bootstrap_label_options[:text].present?
          bootstrap_label_options[:text]
        else
          ActionView::Helpers::Tags::Label::LabelBuilder
            .new(@template, @object_name.to_s, method, @object, nil).translation
        end

        label = content_tag(:legend, class: "col-form-label") do
          label_text
        end
      end

      content_tag(:fieldset, class: "form-group") do
        concat label
        concat yield
      end
    end

    def add_css_class!(options, string)
      css_class = [options[:class], string].compact.join(" ")
      options[:class] = css_class if css_class.present?
    end

    def remove_css_class!(options, string)
      css_class = options[:class].to_s.split(" ")
      options[:class] = (css_class - [string]).compact.join(" ")
      options.delete(:class) if options[:class].blank?
    end

  end

end
