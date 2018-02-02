class BootstrapController < ApplicationController

  def form
    @user = User.new(test: "Read only string")

    @user_with_error = User.new
    @user_with_error.errors.add(:email)
    @user_with_error.errors.add(:terms)
    @user_with_error.errors.add(:test)
  end

end
