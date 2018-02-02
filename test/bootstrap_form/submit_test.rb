require_relative "../test_helper"

class SubmitTest < ActionView::TestCase

  setup do
    @user     = User.new
    @builder  = BootstrapForm::FormBuilder.new(:user, @user, self, {})
  end

  def test_submit
    expected = <<-HTML
      <input class="btn" name="commit" type="submit" value="Create User" />
    HTML
    assert_xml_equal expected, @builder.submit
  end

  def test_primary
    expected = <<-HTML
      <input class="btn-primary btn" name="commit" type="submit" value="Create User" />
    HTML
    assert_xml_equal expected, @builder.primary
  end

  def test_submit_with_label
    expected = <<-HTML
      <input class="btn" name="commit" type="submit" value="Test" />
    HTML
    assert_xml_equal expected, @builder.submit("Test")
  end

  def test_submit_with_css_class
    expected = <<-HTML
      <input class="custom btn" name="commit" type="submit" value="Create User" />
    HTML
    assert_xml_equal expected, @builder.submit(class: "custom")
  end

  def test_submit_with_block
    actual = @builder.submit do
      %{<a href="/" class="btn btn-link">Cancel</a>}.html_safe
    end
    expected = <<-HTML
      <input class="btn" name="commit" type="submit" value="Create User"/>
      <a href="/" class="btn btn-link">Cancel</a>
    HTML
    assert_xml_equal expected, actual
  end

end
