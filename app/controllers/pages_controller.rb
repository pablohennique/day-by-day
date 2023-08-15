class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home tactics]

  def home
  end

  def tactics
  end
end
