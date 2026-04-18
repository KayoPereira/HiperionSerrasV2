module Users
  class RegistrationsController < Devise::RegistrationsController
    before_action :ensure_admin_signup_key!, only: [ :new, :create ]

    private

    def ensure_admin_signup_key!
      return if params[:admin] == "kayo"

      render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
    end
  end
end