require_relative 'helpers/bootstrap'

module BootstrapForm
  class FormBuilder < ActionView::Helpers::FormBuilder

    # TODO: Remove
    include BootstrapForm::Helpers::Bootstrap

    FIELD_HELPERS = %w[
      color_field
      date_field
      datetime_field
      datetime_local_field
      email_field
      month_field
      number_field
      password_field
      phone_field
      range_field
      search_field
      telephone_field
      text_area
      text_field
      time_field
      url_field
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
    #   <%= form.select :choices, ["a", "b"], {}, {bootstrap: {label: {text: "Custom"}}} %>
    #
    def select(method, choices = nil, options = {}, html_options = {}, &block)
      bootstrap_options = (html_options.delete(:bootstrap) || {}).freeze
      draw_form_group(bootstrap_options, method, html_options) do
        super(method, choices, options, html_options, &block)
      end
    end

    # Add bootstrap formatted submit button. If you need to change its type or
    # add another css class, you need to override all css classes like so:
    #
    #   <%= form.submit class: "btn btn-info custom-class" %>
    #
    # You may add additional content that directly follows the button. Here's
    # an example of a cancel link:
    #
    #   <%= form.submit do %>
    #     <%= link_to "Cancel", "/", class: "btn btn-link" %>
    #   <% end %>
    #
    def submit(value = nil, options = {}, &block)
      out = super(value, options.reverse_merge(class: "btn"))
      out += capture(&block) if block_given?

      # TODO: do offset if needed
      out
    end

    # Same as submit button, only with btn-primary class added
    def primary(value = nil, options = {}, &block)
      submit(value, append_css_class!(options, "btn btn-primary"), &block)
    end

    # Wrapper for all field helpers. Example usage:
    #
    #   <%= bootstrap_form_with model: @user do |form| %>
    #     <%= form.text_field :name %>
    #   <% end %>
    #
    # Output of the `text_field` will be wrapped in Bootstrap markup
    #
    def field_helper(method, options, &block)
      bootstrap_options = (options.delete(:bootstrap) || {}).freeze
      draw_form_group(bootstrap_options, method, options) do
        yield
      end
    end

    # todo: private
    def draw_form_group(bootstrap_options, method, options, &block)
      bootstrap_label_options   = (bootstrap_options[:label]    || {}).freeze
      bootstrap_control_options = (bootstrap_options[:control]  || {}).freeze

      label = draw_label(bootstrap_label_options, method)

      control = draw_control(bootstrap_control_options, method, options) do
        yield
      end

      help_text = draw_help(bootstrap_options[:help])

      content_tag(:div, class: "form-group") do
        concat label
        concat control
        concat help_text
      end
    end

    # todo: private
    # Renders label for a given field. Takes following bootstrap options:
    #
    # :text   - replace default label text
    # :class  - css class on the label
    # :hide   - if `true` will render for screen readers only
    #
    # This is how those options can be passed in:
    #
    #   <%= form.text_field :value, bootstrap: {label: {text: "Custom", class: "custom"}} %>
    #
    def draw_label(bootstrap_label_options, method)
      text    = nil
      options = {}

      if (custom_text = bootstrap_label_options[:text]).present?
        text = custom_text
      end

      append_css_class!(options, bootstrap_label_options[:class])
      append_css_class!(options, "sr-only") if bootstrap_label_options[:hide]

      label(method, text, options)
    end

    # todo: private
    # Renders control for a given field. Takes following bootstrap options:
    #
    # :class - custom css class
    #
    # Example how those options are passed in:
    #
    #   <%= form.text_field :value, bootstrap: {control: {class: "custom"}} %>
    #
    def draw_control(bootstrap_control_options, method, options, &block)
      append_css_class!(options, "form-control")

      # TODO: is this even needed? class option comes directly from field
      append_css_class!(options, bootstrap_control_options[:class])

      capture(&block)
    end

    # todo: private
    # Drawing boostrap form field help text. Example usage:
    #
    #   <%= form.text_field :value, bootstrap: {help: "help text"} %>
    #
    def draw_help(text)
      return if text.blank?
      content_tag(:small, text, class: "form-text text-muted")
    end

    # todo: private
    def append_css_class!(options, string)
      css_class = [options[:class], string].compact.join(" ")
      options[:class] = css_class if css_class.present?
    end













    # VVV REWORK ALL OF THAT VVV


    attr_reader :layout, :label_col, :control_col, :has_error, :inline_errors, :label_errors, :acts_like_form_tag



    DATE_SELECT_HELPERS = %w{date_select time_select datetime_select}



    delegate :content_tag, :capture, :concat, to: :@template










    #   define_method(method_name) do |name, options = {}|
    #     bootstrap_options = options.delete(:boostrap)

    #     form_group_builder(name, options) do
    #       prepend_and_append_input(options) do
    #         super(name, options)
    #       end
    #     end
    #   end
    # end

    DATE_SELECT_HELPERS.each do |method_name|
      define_method(method_name) do |name, options = {}, html_options = {}|
        form_group_builder(name, options, html_options) do
          content_tag(
            :div,
            super(name, options, html_options),
            class: control_specific_class(method_name)
          )
        end
      end
    end

    def file_field(name, options = {})
      form_group_builder(name, options.reverse_merge(control_class: nil)) do
        super(name, options)
      end
    end

    # def select(method, choices = nil, options = {}, html_options = {}, &block)
    #   form_group_builder(method, options, html_options) do
    #     prepend_and_append_input(options) do
    #       super(method, choices, options, html_options, &block)
    #     end
    #   end
    # end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        super(method, collection, value_method, text_method, options, html_options)
      end
    end

    def grouped_collection_select(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        super(method, collection, group_method, group_label_method, option_key_method, option_value_method, options, html_options)
      end
    end

    def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
      form_group_builder(method, options, html_options) do
        super(method, priority_zones, options, html_options)
      end
    end

    def check_box(name, options = {}, checked_value = "1", unchecked_value = "0", &block)
      options = options.symbolize_keys!
      check_box_options = options.except(:label, :label_class, :help, :inline, :custom)
      if options[:custom]
        validation = nil
        validation = "is-invalid" if has_error?(name)
        check_box_options[:class] = ["custom-control-input", validation, check_box_options[:class]].compact.join(' ')
      else
        check_box_options[:class] = ["form-check-input", check_box_options[:class]].compact.join(' ')
      end

      checkbox_html = super(name, check_box_options, checked_value, unchecked_value)
      label_content = block_given? ? capture(&block) : options[:label]
      label_description = label_content || (object && object.class.human_attribute_name(name)) || name.to_s.humanize
      if options[:custom]
        html = label_description
      else
        html = checkbox_html.concat(" ").concat(label_description)
      end

      label_name = name
      # label's `for` attribute needs to match checkbox tag's id,
      # IE sanitized value, IE
      # https://github.com/rails/rails/blob/c57e7239a8b82957bcb07534cb7c1a3dcef71864/actionview/lib/action_view/helpers/tags/base.rb#L116-L118
      if options[:multiple]
        label_name =
          "#{name}_#{checked_value.to_s.gsub(/\s/, "_").gsub(/[^-\w]/, "").downcase}"
      end

      label_class = options[:label_class]

      if options[:custom]
        div_class = ["custom-control", "custom-checkbox"]
        div_class.append("custom-control-inline") if options[:inline]
        content_tag(:div, class: div_class.compact.join(" ")) do
          checkbox_html.concat(label(label_name, html, class: ["custom-control-label", label_class].compact.join(" ")))
        end
      else
        disabled_class = " disabled" if options[:disabled]
        if options[:inline]
          label_class = " #{label_class}" if label_class
          label(label_name, html, class: "form-check-inline#{disabled_class}#{label_class}")
        else
          content_tag(:div, class: "form-check#{disabled_class}") do
            label(label_name, html, class: ["form-check-label", label_class].compact.join(" "))
          end
        end
      end
    end

    def radio_button(name, value, *args)
      options = args.extract_options!.symbolize_keys!
      radio_options = options.except(:label, :label_class, :help, :inline, :custom)
      radio_options[:class] = ["custom-control-input", options[:class]].compact.join(' ') if options[:custom]
      args << radio_options
      radio_html = super(name, value, *args)
      if options[:custom]
        html = options[:label]
      else
        html = radio_html.concat(" ").concat(options[:label])
      end

      disabled_class = " disabled" if options[:disabled]
      label_class    = options[:label_class]

      if options[:custom]
        div_class = ["custom-control", "custom-radio"]
        div_class.append("custom-control-inline") if options[:inline]
        content_tag(:div, class: div_class.compact.join(" ")) do
          radio_html.concat(label(name, html, value: value, class: ["custom-control-label", label_class].compact.join(" ")))
        end
      else
        if options[:inline]
          label_class = " #{label_class}" if label_class
          label(name, html, class: "radio-inline#{disabled_class}#{label_class}", value: value)
        else
          content_tag(:div, class: "radio#{disabled_class}") do
            label(name, html, value: value, class: label_class)
          end
        end
      end
    end

    def collection_check_boxes(*args)
      html = inputs_collection(*args) do |name, value, options|
        options[:multiple] = true
        check_box(name, options, value, nil)
      end
      hidden_field(args.first,{value: "", multiple: true}).concat(html)
    end

    def collection_radio_buttons(*args)
      inputs_collection(*args) do |name, value, options|
        radio_button(name, value, options)
      end
    end

    # TODO: Needs documention
    # def form_group(*args, &block)
    #   options = args.extract_options!
    #   name = args.first

    #   options[:class] = ["form-group", options[:class]].compact.join(' ')
    #   options[:class] << " row" if get_group_layout(options[:layout]) == :horizontal
    #   options[:class] << " #{feedback_class}" if options[:icon]

    #   content_tag(:div, options.except(:id, :label, :help, :icon, :label_col, :control_col, :layout)) do
    #     label = generate_label(options[:id], name, options[:label], options[:label_col], options[:layout]) if options[:label]
    #     control = capture(&block).to_s
    #     control.concat(generate_help(name, options[:help]).to_s)

    #     if get_group_layout(options[:layout]) == :horizontal
    #       control_class = options[:control_col] || control_col
    #       unless options[:label]
    #         control_offset = offset_col(options[:label_col] || @label_col)
    #         control_class = "#{control_class} #{control_offset}"
    #       end
    #       control = content_tag(:div, control, class: control_class)
    #     end

    #     concat(label).concat(control)
    #   end
    # end

    def fields_for(record_name, record_object = nil, fields_options = {}, &block)
      fields_options, record_object = record_object, nil if record_object.is_a?(Hash) && record_object.extractable_options?
      fields_options[:layout] ||= options[:layout]
      fields_options[:label_col] = fields_options[:label_col].present? ? "#{fields_options[:label_col]}" : options[:label_col]
      fields_options[:control_col] ||= options[:control_col]
      fields_options[:inline_errors] ||= options[:inline_errors]
      fields_options[:label_errors] ||= options[:label_errors]
      super(record_name, record_object, fields_options, &block)
    end



  private

    def horizontal?
      layout == :horizontal
    end

    def get_group_layout(group_layout)
      group_layout || layout
    end

    def default_label_col
      "col-sm-2"
    end

    def offset_col(label_col)
      label_col.sub(/^col-(\w+)-(\d)$/, 'offset-\1-\2')
    end

    def default_control_col
      "col-sm-10"
    end

    def hide_class
      "sr-only" # still accessible for screen readers
    end

    def control_class
      "form-control"
    end

    def feedback_class
      "has-feedback"
    end

    def control_specific_class(method)
      "rails-bootstrap-forms-#{method.gsub(/_/, "-")}"
    end

    def has_error?(name)
      object.respond_to?(:errors) && !(name.nil? || object.errors[name].empty?)
    end

    def required_attribute?(obj, attribute)

      return false unless obj and attribute

      target = (obj.class == Class) ? obj : obj.class

      target_validators = if target.respond_to? :validators_on
                            target.validators_on(attribute).map(&:class)
                          else
                            []
                          end

      has_presence_validator = target_validators.include?(
                                 ActiveModel::Validations::PresenceValidator)

      if defined? ActiveRecord::Validations::PresenceValidator
        has_presence_validator |= target_validators.include?(
                                    ActiveRecord::Validations::PresenceValidator)
      end

      has_presence_validator
    end

    def form_group_builder(method, options, html_options = nil)
      options.symbolize_keys!
      html_options.symbolize_keys! if html_options

      # Add control_class; allow it to be overridden by :control_class option
      css_options = html_options || options
      control_classes = css_options.delete(:control_class) { control_class }
      css_options[:class] = [control_classes, css_options[:class]].compact.join(" ")
      css_options[:class] << " is-invalid" if has_error?(method)

      options = convert_form_tag_options(method, options) if acts_like_form_tag

      wrapper_class = css_options.delete(:wrapper_class)
      wrapper_options = css_options.delete(:wrapper)
      help = options.delete(:help)
      icon = options.delete(:icon)
      label_col = options.delete(:label_col)
      control_col = options.delete(:control_col)
      layout = get_group_layout(options.delete(:layout))
      form_group_options = {
        id: options[:id],
        help: help,
        icon: icon,
        label_col: label_col,
        control_col: control_col,
        layout: layout,
        class: wrapper_class
      }

      if wrapper_options.is_a?(Hash)
        form_group_options.merge!(wrapper_options)
      end

      unless options.delete(:skip_label)
        if options[:label].is_a?(Hash)
          label_text  = options[:label].delete(:text)
          label_class = options[:label].delete(:class)
          options.delete(:label)
        end
        label_class ||= options.delete(:label_class)
        label_class = hide_class if options.delete(:hide_label)

        if options[:label].is_a?(String)
          label_text ||= options.delete(:label)
        end

        form_group_options.merge!(label: {
          text: label_text,
          class: label_class,
          skip_required: options.delete(:skip_required)
        })
      end

      form_group(method, form_group_options) do
        yield
      end
    end

    def convert_form_tag_options(method, options = {})
      options[:name] ||= method
      options[:id] ||= method
      options
    end

    def generate_label(id, name, options, custom_label_col, group_layout)
      options[:for] = id if acts_like_form_tag
      classes = [options[:class]]

      if get_group_layout(group_layout) == :horizontal
        classes << "col-form-label"
        classes << (custom_label_col || label_col)
      end

      unless options.delete(:skip_required)
        classes << "required" if required_attribute?(object, name)
      end

      options[:class] = classes.compact.join(" ").strip
      options.delete(:class) if options[:class].empty?

      if label_errors && has_error?(name)
        error_messages = get_error_messages(name)
        label_text = (options[:text] || object.class.human_attribute_name(name)).to_s.concat(" #{error_messages}")
        label(name, label_text, options.except(:text))
      else
        label(name, options[:text], options.except(:text))
      end

    end

    def generate_help(name, help_text)
      if has_error?(name) && inline_errors
        help_text = get_error_messages(name)
        help_klass = 'invalid-feedback'
        help_tag = :div
      end
      return if help_text == false

      help_klass ||= 'form-text text-muted'
      help_text ||= get_help_text_by_i18n_key(name)
      help_tag ||= :small

      content_tag(help_tag, help_text, class: help_klass) if help_text.present?
    end

    def get_error_messages(name)
      object.errors[name].join(", ")
    end

    def inputs_collection(name, collection, value, text, options = {}, &block)
      form_group_builder(name, options) do
        inputs = ""

        collection.each do |obj|
          input_options = options.merge(label: text.respond_to?(:call) ? text.call(obj) : obj.send(text))

          input_value = value.respond_to?(:call) ? value.call(obj) : obj.send(value)
          if checked = input_options[:checked]
            input_options[:checked] = checked == input_value                     ||
                                      Array(checked).try(:include?, input_value) ||
                                      checked == obj                             ||
                                      Array(checked).try(:include?, obj)
          end

          input_options.delete(:class)
          inputs << block.call(name, input_value, input_options)
        end

        inputs.html_safe
      end
    end

    def get_help_text_by_i18n_key(name)
      if object

        if object.class.respond_to?(:model_name)
          partial_scope = object.class.model_name.name
        else
          partial_scope = object.class.name
        end

        underscored_scope = "activerecord.help.#{partial_scope.underscore}"
        downcased_scope = "activerecord.help.#{partial_scope.downcase}"
        help_text = I18n.t(name, scope: underscored_scope, default: '').presence
        help_text ||= if text = I18n.t(name, scope: downcased_scope, default: '').presence
                        warn "I18n key '#{downcased_scope}.#{name}' is deprecated, use '#{underscored_scope}.#{name}' instead"
                        text
                      end
        help_text ||= I18n.t("#{name}_html", scope: underscored_scope, default: '').html_safe.presence
        help_text ||= if text = I18n.t("#{name}_html", scope: downcased_scope, default: '').html_safe.presence
                        warn "I18n key '#{downcased_scope}.#{name}' is deprecated, use '#{underscored_scope}.#{name}' instead"
                        text
                      end
        help_text
      end
    end

  end
end
