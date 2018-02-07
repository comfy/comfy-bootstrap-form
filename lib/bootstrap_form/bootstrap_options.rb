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
      label_col_class.sub(/\Acol-(\w+)-(\d+)\z/, 'offset-\1-\2')
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
      scope = self.clone
      scope.set_options(options)
      scope
    end

  private

    def set_defaults
      @layout               = "vertical"
      @label_col_class      = "col-sm-2"
      @control_col_class    = "col-sm-10"
      @label_align_class    = "text-sm-right"
      @inline_margin_class  = "mr-sm-2"
    end

    def set_options(options = {})
      options.is_a?(Hash) && options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

  end

end
