# frozen_string_literal: true

require_relative "../test_helper"

class ModelsTest < ActionView::TestCase

  if Rails.version >= "6.0"
    include ActionText::TagHelper
  end

  def test_activerecord_model
    user     = User.new
    builder  = ComfyBootstrapForm::FormBuilder.new(:user, user, self, bootstrap: {})
    actual = builder.text_field(:email)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_email">Email</label>
        <input class="form-control" type="text" name="user[email]" id="user_email" />
      </div>
    HTML
    assert_xml_equal expected, actual
  end

  def test_openstruct_model
    user     = OpenStruct.new(email: nil)
    builder  = ComfyBootstrapForm::FormBuilder.new(:user, user, self, bootstrap: {})
    actual = builder.text_field(:email)
    expected = <<-HTML
      <div class="form-group">
        <label for="user_email">Email</label>
        <input class="form-control" type="text" name="user[email]" id="user_email" />
      </div>
    HTML
    assert_xml_equal expected, actual
  end

end
