class BootstrapController < ApplicationController

  def form
    @user = User.new(test: "Lorem ipsum")

    @user_with_error = User.new
    @user_with_error.errors.add(:username,      "Username already taken")
    @user_with_error.errors.add(:email,         "Invalid email address")
    @user_with_error.errors.add(:password,      "Another user already uses this password")
    @user_with_error.errors.add(:color,         "Red is the worst color. Choose another.")
    @user_with_error.errors.add(:bio,           "Too much information")
    @user_with_error.errors.add(:locale,        "It's fine, but here's another error")
    @user_with_error.errors.add(:date,          "Invalid date")
    @user_with_error.errors.add(:datetime,      "Invalid date and time")
    @user_with_error.errors.add(:time,          "Invalid time")
    @user_with_error.errors.add(:rich_content,  "Too rich, or not rich enough")
    @user_with_error.errors.add(:terms,         "You never agreed to Terms and Conditions")

    @user_with_error.errors.add(:test, "Generic error message")
    ("a".."z").each do |letter|
      @user_with_error.errors.add("test_#{letter}", "Generic error message")
    end
  end

end
