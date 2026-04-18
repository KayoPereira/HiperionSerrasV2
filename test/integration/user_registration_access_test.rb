require "test_helper"

class UserRegistrationAccessTest < ActionDispatch::IntegrationTest
  test "sign up returns 404 without admin param" do
    get new_user_registration_path

    assert_response :not_found
  end

  test "sign up page is accessible with valid admin param" do
    get new_user_registration_path(admin: "kayo")

    assert_response :success
  end

  test "user creation returns 404 without admin param" do
    post user_registration_path, params: {
      user: {
        email: "blocked@example.com",
        password: "12345678",
        password_confirmation: "12345678"
      }
    }

    assert_response :not_found
  end

  test "user creation works with valid admin param" do
    assert_difference("User.count", 1) do
      post user_registration_path(admin: "kayo"), params: {
        user: {
          email: "allowed@example.com",
          password: "12345678",
          password_confirmation: "12345678"
        }
      }
    end

    assert_redirected_to root_path
  end
end