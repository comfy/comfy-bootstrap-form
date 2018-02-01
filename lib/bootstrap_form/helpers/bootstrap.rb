module BootstrapForm
  module Helpers
    module Bootstrap

      def error_summary
        content_tag :ul, class: 'rails-bootstrap-forms-error-summary' do
          object.errors.full_messages.each do |error|
            concat content_tag(:li, error)
          end
        end
      end

      def errors_on(name, options = {})
        if has_error?(name)
          hide_attribute_name = options[:hide_attribute_name] || false

          content_tag :div, class: "alert alert-danger" do
            if hide_attribute_name
              object.errors[name].join(", ")
            else
              object.errors.full_messages_for(name).join(", ")
            end
          end
        end
      end

      def static_control(*args, &block)
        options = args.extract_options!
        name = args.first

        html = if block_given?
          capture(&block)
        else
          object.send(name)
        end

        form_group_builder(name, options) do
          content_tag(:p, html, class: static_class)
        end
      end

      def custom_control(*args, &block)
        options = args.extract_options!
        name = args.first

        form_group_builder(name, options, &block)
      end

      def static_class
        "form-control-static"
      end
    end
  end
end
