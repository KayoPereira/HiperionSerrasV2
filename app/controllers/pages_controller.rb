class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :about, :contact, :budget, :privacy_policies ]

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

  def privacy_policies
  end
end
