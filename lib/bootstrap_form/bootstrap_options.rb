module BootstrapForm
  # Container for bootstrap specific form builder options. It controls options
  # that define form layout and grid sizing. They are passed-in into form helper
  # and field helpers via `:bootstrap` option. For example:
  #
  #   bootstrap_form_with scope: :login, url: "/login", bootstrap: {layout: :inline} do |f|
  #      f.text_field :username, bootstrap: {label: {text: "Your username"}}
  #   end
  #
  class BootstrapOptions

    # Controls form layout. Can be: "vertical" (default), "horizontal" or "inline"
    attr_reader :layout

    # CSS class for label column when using horizontal form. Default: "col-sm-2"
    attr_reader :label_col_class

    # CSS class for control column when using horizontal form. Default: "col-sm-10"
    attr_reader :control_col_class

    # CSS class for label alignment in horizontal form. Default: "text-sm-right"
    attr_reader :label_align_class

    # CSS class used to space out form groups for inline forms. Default: "mr-sm-2"
    attr_reader :inline_margin_class

    # Label specific options. Default is and empty hash. Options are as follows:
    #   text:   "Label Text"  - override automatically generated label text
    #   hide:   true          - label only visible to screen readers
    #   class:  "custom"      - append custom CSS class
    # Example:
    #
    #   form.label :username, bootstrap: {label: {text: "Name", class: "important"}}
    #
    attr_reader :label

    # Input groups allow prepending and appending arbitrary html. By default
    # these are nil. Example usage:
    #
    #   form.text_field :dollars, bootstrap: {prepend: "$", append: ".00"}
    #
    # For non-text values, use hash like so:
    #
    #   form.text_field :search, bootstrap: {append: {html: "<button>Go</button>".html_safe}}
    #
    attr_reader :prepend
    attr_reader :append

    # Help text that goes under the form field. Example usage:
    #
    #   form.password_field :password, bootstrap: {help: "Password should be more than 8 characters in length"}
    #
    attr_reader :help

    # Options to render checkboxes and radio buttons inline. Default is false. Example:
    #
    #   form.collection_radio_buttons :choices, ["yes", "no"], :to_s, :to_s, bootstrap: {check_inline: true}
    #
    attr_reader :check_inline

    def initialize(options = {})
      set_defaults
      set_options(options)
    end

    def horizontal?
      @layout.to_s == "horizontal"
    end

    def inline?
      @layout.to_s == "inline"
    end

    def offset_col_class
      label_col_class.sub(%r{\Acol-(\w+)-(\d+)\z}, 'offset-\1-\2')
    end

    # This will return a copy of BootstrapOptions object with new options set
    # that don't affect original object. This way we can have options specific
    # to a given form field. For example, we can change grid just for one field:
    #
    #   bootstrap_form_with scope: :login do |f|
    #     f.text_field :email, bootstrap: {label_col_class: "col-md-6", control_col_class: "col-md-6"}
    #     f.password_field :password
    #   end
    #
    def scoped(options = {})
      scope = clone
      scope.set_options(options)
      scope
    end

    def set_options(options = {})
      options.is_a?(Hash) && options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

  private

    def set_defaults
      @layout               = "vertical"
      @label_col_class      = "col-sm-2"
      @control_col_class    = "col-sm-10"
      @label_align_class    = "text-sm-right"
      @inline_margin_class  = "mr-sm-2"
      @label                = {}
      @append               = nil
      @prepend              = nil
      @help                 = nil
      @check_inline         = false
    end

  end
end
