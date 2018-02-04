module BootstrapForm
  module ViewHelper

    # Wrapper for `form_with`. Passing in Bootstrap form builder.
    def bootstrap_form_with(**options, &block)
      supress_field_errors do
        css_classes       = options.delete(:class) || ""
        bootstrap_options = options[:bootstrap] || {}

        if bootstrap_options[:layout].to_s == "inline"
          css_classes << " form-inline"
        end

        form_options = options.reverse_merge(builder: BootstrapForm::FormBuilder)
        form_options.merge!(class: css_classes) unless css_classes.blank?
        form_with(**form_options, &block)
      end
    end

  private

    # By default, Rails will wrap form fields with extra html to indicate
    # inputs with errors. We need to handle this in the builder to render
    # Bootstrap specific markup. So we need to bypass this.
    def supress_field_errors
      original_proc = ActionView::Base.field_error_proc
      ActionView::Base.field_error_proc = proc { |input, instance| input }
      yield
    ensure
      ActionView::Base.field_error_proc = original_proc
    end
  end
end
