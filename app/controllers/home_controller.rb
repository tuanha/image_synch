class HomeController < ApplicationController
  def welcome
    redirect_to '/admin' if current_user.admin
  end
end
