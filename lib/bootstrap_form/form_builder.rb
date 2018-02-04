module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder

    FIELD_HELPERS = %w[
      color_field     file_field      phone_field   text_field
      date_field      month_field     range_field   time_field
      datetime_field  number_field    search_field  url_field
      email_field     password_field  text_area     week_field
    ].freeze

    # Container for bootstrap specific form builder options. It controls options
    # that define form layout and grid sizing.
    class BootstrapOptions

      attr_reader :layout,
                  :label_col_class,
                  :control_col_class,
                  :label_align_class,
                  :inline_margin_class

      def initialize(options = {})
        @layout               = options[:layout]              || "default"
        @label_col_class      = options[:label_col_class]     || "col-sm-2"
        @control_col_class    = options[:control_col_class]   || "col-sm-10"
        @label_align_class    = options[:label_align_class]   || "text-sm-right"
        @inline_margin_class  = options[:inline_margin_class] || "mr-sm-2"
      end

      def horizontal?
        @layout.to_s == "horizontal"
      end

      def inline?
        @layout.to_s == "inline"
      end

      def offset_col_class
        label_col_class.sub(/\Acol-(\w+)-(\d+)\z/, 'offset-\1-\2')
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
      bootstrap_options       = options.delete(:bootstrap) || {}
      bootstrap_label_options = bootstrap_options[:label] || {}

      help_text = draw_help(bootstrap_options[:help])
      errors    = draw_errors(method)

      add_css_class!(options, "form-check-input")
      add_css_class!(options, "is-invalid") if errors.present?

      label_text = nil
      if (custom_text = bootstrap_label_options[:text]).present?
        label_text = custom_text
      end

      fieldset_css_class = "form-group"
      fieldset_css_class << " row" if bootstrap.horizontal?
      fieldset_css_class << " #{bootstrap.inline_margin_class}" if bootstrap.inline?

      content_tag(:fieldset, class: fieldset_css_class) do
        draw_control_column(offset: true) do
          content_tag(:div, class: "form-check") do
            concat super(method, options, checked_value, unchecked_value)
            concat label(method, label_text, class: "form-check-label")
            concat errors     if errors.present?
            concat help_text  if help_text.present?
          end
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

      form_group_class = "form-group"
      form_group_class << " row" if bootstrap.horizontal?

      content_tag(:div, class: form_group_class) do
        draw_control_column(offset: true) do
          out = super(value, options)
          out << capture(&block) if block_given?
          out
        end
      end
    end

    # Same as submit button, only with btn-primary class added
    def primary(value = nil, options = {}, &block)
      add_css_class!(options, "btn-primary")
      submit(value, options, &block)
    end

    # Helper method to put arbitrary content in markup that renders correctly
    # for the Bootstrap form. Example:
    #
    #   form_group bootstrap: {label: {text: "Label"}} do
    #     "Some content"
    #   end
    #
    def form_group(options = {}, &block)
      bootstrap_options       = options.delete(:bootstrap) || {}
      bootstrap_label_options = bootstrap_options.delete(:label) || {}

      label_text = bootstrap_label_options[:text]

      label = if label_text.present?
        label_options = {}
        add_css_class!(label_options, bootstrap_label_options[:class])

        if bootstrap.horizontal?
          add_css_class!(label_options, "col-form-label")
          add_css_class!(label_options, bootstrap.label_col_class)
          add_css_class!(label_options, bootstrap.label_align_class)
        elsif bootstrap.inline?
          add_css_class!(label_options, bootstrap.inline_margin_class)
        end

        content_tag(:label, label_text, label_options)
      end

      form_group_class = "form-group"
      form_group_class << " row"      if bootstrap.horizontal?
      form_group_class << " mr-sm-2"  if bootstrap.inline?

      content_tag(:div, class: form_group_class) do
        content = ""
        content << label if label.present?
        content << draw_control_column(offset: label.blank?) do
          yield
        end
        content.html_safe
      end
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
      label  = draw_label(bootstrap_options, method)
      errors = draw_errors(method)

      control = draw_control(bootstrap_options, errors, method, options) do
        yield
      end

      form_group_class = "form-group"
      form_group_class << " row"      if bootstrap.horizontal?
      form_group_class << " mr-sm-2"  if bootstrap.inline?

      content_tag(:div, class: form_group_class) do
        concat label
        concat control
      end
    end

    def draw_errors(method)
      return unless (errors = object && object.errors[method]).present?

      content_tag(:div, class: "invalid-feedback") do
        errors.join(", ")
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
    def draw_label(bootstrap_options, method)
      bootstrap_label_options = bootstrap_options[:label] || {}

      text    = nil
      options = {}

      if (custom_text = bootstrap_label_options[:text]).present?
        text = custom_text
      end

      add_css_class!(options, bootstrap_label_options[:class])
      add_css_class!(options, "sr-only") if bootstrap_label_options[:hide]
      add_css_class!(options, bootstrap.inline_margin_class) if bootstrap.inline?

      if bootstrap.horizontal?
        add_css_class!(options, "col-form-label")
        add_css_class!(options, bootstrap.label_col_class)
        add_css_class!(options, bootstrap.label_align_class)
      end

      label(method, text, options)
    end

    # Renders control for a given field
    def draw_control(bootstrap_options, errors, method, options, &block)
      bootstrap_label_options  = bootstrap_options[:label] || {}

      add_css_class!(options, "form-control")
      add_css_class!(options, "is-invalid") if errors.present?

      offset = !!bootstrap_label_options[:hide]

      draw_control_column(offset: offset) do
        draw_input_group(bootstrap_options, errors) do
          yield
        end
      end
    end

    # Wrapping in control in column wrapper
    #
    def draw_control_column(offset:, &block)
      return yield unless bootstrap.horizontal?
      css_class = "#{bootstrap.control_col_class}"
      css_class << " #{bootstrap.offset_col_class}" if offset
      content_tag(:div, class: css_class) do
        yield
      end
    end

    # Wraps input field in input group container that allows prepending and
    # appending text or html. Example:
    #
    #   text_field(:value, bootstrap: {prepend: "$.$$"}})
    #   text_field(:value, bootstrap: {append: {html: "<button>Go</button>"}}})
    #
    def draw_input_group(bootstrap_options, errors, &block)
      prepend_html  = draw_input_group_content(bootstrap_options, :prepend)
      append_html   = draw_input_group_content(bootstrap_options, :append)

      help_text = draw_help(bootstrap_options[:help])

      # Not prepending or appending anything. Bail.
      if prepend_html.blank? && append_html.blank?
        content = capture(&block)
        content << errors     if errors.present?
        content << help_text  if help_text.present?
        return content
      end

      content_tag(:div, class: "input-group") do
        concat prepend_html if prepend_html.present?
        concat capture(&block)
        concat append_html  if append_html.present?
        concat errors       if errors.present?
        concat help_text    if help_text.present?
      end
    end

    def draw_input_group_content(bootstrap_options, type)
      value = bootstrap_options[type]
      return unless value.present?

      content_tag(:div, class: "input-group-#{type}") do
        if value.is_a?(Hash) && value[:html].present?
          value[:html]
        else
          content_tag(:span, value, class: "input-group-text")
        end
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

        errors    = draw_errors(method)
        help_text = draw_help(bootstrap_options[:help])

        add_css_class!(options, "is-invalid") if errors.present?

        content = choices.each_with_index.map do |(input_value, label_text), index|
          content_tag(:div, class: form_check_css_class) do
            concat input.call(method, input_value, options)
            concat label(method, label_text, value: input_value, class: "form-check-label")
            if ((choices.count - 1) == index) && !bootstrap_options[:inline]
              concat errors     if errors.present?
              concat help_text  if help_text.present?
            end
          end
        end.join.html_safe

        if bootstrap_options[:inline]
          content << errors     if errors.present?
          content << help_text  if help_text.present?
        end

        content
      end
    end

    # Wrapper for collections of radio buttons and checkboxes
    def draw_form_group_fieldset(bootstrap_options, method, options, &block)
      bootstrap_label_options = bootstrap_options[:label] || {}

      unless bootstrap_label_options[:hide]
        label_text = bootstrap_label_options.delete(:text)
        label_text ||= ActionView::Helpers::Tags::Label::LabelBuilder
          .new(@template, @object_name.to_s, method, @object, nil).translation

        add_css_class!(bootstrap_label_options, "col-form-label pt-0")

        if bootstrap.horizontal?
          add_css_class!(bootstrap_label_options, bootstrap.label_col_class)
          add_css_class!(bootstrap_label_options, bootstrap.label_align_class)
        end

        label = content_tag(:legend, bootstrap_label_options) do
          label_text
        end
      end

      content_tag(:fieldset, class: "form-group") do
        content = ""
        content << label if label.present?
        content << draw_control_column(offset: bootstrap_label_options[:hide]) do
          yield
        end

        if bootstrap.horizontal?
          content_tag(:div, content.html_safe, class: "row")
        else
          content.html_safe
        end
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
