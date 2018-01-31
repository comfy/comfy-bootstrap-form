module BootstrapForm
  module ViewHelper

    # Wrapper for `form_with`. Passing in Bootstrap form builder.
    def bootstrap_form_with(**options, &block)
      supress_field_errors do
        form_with(**options.merge(builder: BootstrapForm::FormBuilder), &block)
      end
    end

    def horizontal_bootstrap_form_with(**options, &block)
      # TODO
    end

    def inline_boostrap_form_with(**options, &block)
      # TODO
    end

    def bootstrap_fields(scope = nil, model: nil, **options, &block)
      # TODO
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
