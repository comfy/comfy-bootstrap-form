module BootstrapForm
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
end
