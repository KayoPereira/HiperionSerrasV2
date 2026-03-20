class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :about, :contact ]

  def home
  end

  def about
  end

  def contact
    @contact_message = ContactMessage.new
  end
end
