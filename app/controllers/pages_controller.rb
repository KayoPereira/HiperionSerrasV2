class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :about, :contact, :budget ]

  def home
  end

  def about
  end

  def contact
    @contact_message = ContactMessage.new
  end

  def budget
    @budget_request = BudgetRequest.new
  end
end
