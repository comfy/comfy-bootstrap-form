require_relative "../test_helper"

class InputGroupTest < ActionView::TestCase

  setup do
    @user     = User.new
    @builder  = BootstrapForm::FormBuilder.new(:user, @user, self, {})
  end

  def test_input_group
    actual = @builder.text_field(:test, bootstrap: {
      prepend: "prepend", append: "append"
    })
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <div class="input-group">
          <div class="input-group-prepend">
            <span class="input-group-text">prepend</span>
          </div>
          <input class="form-control" id="user_test" name="user[test]" type="text"/>
          <div class="input-group-append">
            <span class="input-group-text">append</span>
          </div>
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_input_group_with_html
    actual = @builder.text_field(:test, bootstrap: {
      prepend: {html: "<button>Go</button>".html_safe},
      append: {html: "<button>Stop</button>".html_safe}
    })
    expected = <<-HTML
      <div class="form-group">
        <label for="user_test">Test</label>
        <div class="input-group">
          <div class="input-group-prepend">
            <button>Go</button>
          </div>
          <input class="form-control" id="user_test" name="user[test]" type="text"/>
          <div class="input-group-append">
            <button>Stop</button>
          </div>
        </div>
      </div>
    HTML
    assert_xml_equal expected, actual
  end

end
