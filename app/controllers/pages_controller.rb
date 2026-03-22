class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home, :about, :contact, :budget, :privacy_policies, :cookies_policies, :terms_of_use ]

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

  def cookies_policies
  end

  def terms_of_use
  end
end
