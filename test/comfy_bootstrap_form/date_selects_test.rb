# frozen_string_literal: true

require_relative "../test_helper"

class DateSelectsTest < ActionView::TestCase

  setup do
    @user     = User.new
    @builder  = ComfyBootstrapForm::FormBuilder.new(:user, @user, self, bootstrap: { custom_control: false })
  end

  def test_date_select
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      actual = @builder.date_select(:test)
      expected = <<-HTML
        <div class="form-group">
          <label for="user_test">Test</label>
          <div class="date_select">
            <select class="d-inline-block w-auto form-control" id="user_test_1i" name="user[test(1i)]">
              #{options_range(start: 2007, stop: 2017, selected: 2012)}
            </select>
            <select class="d-inline-block w-auto form-control" id="user_test_2i" name="user[test(2i)]">
              #{options_range(start: 1, stop: 12, selected: 2, months: true)}
            </select>
            <select class="d-inline-block w-auto form-control" id="user_test_3i" name="user[test(3i)]">
              #{options_range(start: 1, stop: 31, selected: 3)}
            </select>
          </div>
        </div>
      HTML
      assert_xml_equal expected, actual
    end
  end

  def test_datetime_select
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      actual = @builder.datetime_select(:test)
      expected = <<-HTML
        <div class="form-group">
          <label for="user_test">Test</label>
          <div class="datetime_select">
            <select class="d-inline-block w-auto form-control" id="user_test_1i" name="user[test(1i)]">
              #{options_range(start: 2007, stop: 2017, selected: 2012)}
            </select>
            <select class="d-inline-block w-auto form-control" id="user_test_2i" name="user[test(2i)]">
              #{options_range(start: 1, stop: 12, selected: 2, months: true)}
            </select><select class="d-inline-block w-auto form-control" id="user_test_3i" name="user[test(3i)]">
              #{options_range(start: 1, stop: 31, selected: 3)}
            </select>
            <select class="d-inline-block w-auto form-control" id="user_test_4i" name="user[test(4i)]">
              #{options_range(start: '00', stop: '23', selected: '12')}
            </select>
            :
            <select class="d-inline-block w-auto form-control" id="user_test_5i" name="user[test(5i)]">
              #{options_range(start: '00', stop: '59', selected: '00')}
            </select>
          </div>
        </div>
      HTML
      assert_xml_equal expected, actual
    end
  end

  def test_time_select
    Timecop.freeze(Time.utc(2012, 2, 3, 12, 0, 0)) do
      actual = @builder.time_select(:test)
      expected = <<-HTML
        <div class="form-group">
          <label for="user_test">Test</label>
          <div class="time_select">
            <input id="user_test_1i" name="user[test(1i)]" type="hidden" value="2012"/>
            <input id="user_test_2i" name="user[test(2i)]" type="hidden" value="2"/>
            <input id="user_test_3i" name="user[test(3i)]" type="hidden" value="3"/>
            <select class="d-inline-block w-auto form-control" id="user_test_4i" name="user[test(4i)]">
              #{options_range(start: '00', stop: '23', selected: '12')}
            </select>
            :
            <select class="d-inline-block w-auto form-control" id="user_test_5i" name="user[test(5i)]">
              #{options_range(start: '00', stop: '59', selected: '00')}
            </select>
          </div>
        </div>
      HTML
      assert_xml_equal expected, actual
    end
  end

end
